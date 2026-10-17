#!/usr/bin/env ruby
# frozen_string_literal: true
#
# DK-AI linter. Deterministic, no LLM. Two tiers, kept labelled:
#
#   Tier 1 — OKF conformance (§9 of _okf/SPEC.md). Genuine violations.
#   Tier 2 — local policy. House rules. A bundle that fails only Tier 2 is still
#            conformant OKF; never report Tier 2 findings as "non-conformant".
#
# Usage: ruby bin/lint.rb [--warnings]

require 'yaml'
require 'time'
require 'date'
require 'set'

ROOT = File.expand_path('..', __dir__)
Dir.chdir(ROOT)
Encoding.default_external = Encoding::UTF_8

def read_utf8(path) = File.read(path, encoding: 'UTF-8')

SHOW_WARNINGS = ARGV.include?('--warnings')

ALLOWED_KEYS   = %w[type title description resource tags timestamp].freeze
RESERVED       = %w[index.md log.md].freeze
# Repo-level prose, not part of the bundle graph. Their fenced examples contain
# illustrative links that must not be resolved.
DOC_FILES      = %w[CLAUDE.md README.md].freeze
SKIP_DIRS      = %w[_okf bin .git].freeze

FOLDER_TYPES = {
  'organisations'  => 'Organisation',
  'initiatives'    => 'Initiative',
  'bodies'         => 'Governance Body',
  'people'         => 'Person',
  'events'         => 'Event',
  'funding'        => 'Funding Programme',
  'policy'         => 'Policy',
  'infrastructure' => 'Infrastructure',
  'programmes'     => 'Programme',
  'references'     => 'Reference',
  'snapshots'      => 'Log'
}.freeze

TAGS = Set.new(%w[
  organisation initiative body person event funding policy infrastructure programme reference snapshot
  ucph health
  centre network consortium strategic-initiative working-group cluster steering-committee
  series university faculty department hospital region municipality state-agency ministry
  foundation association
  national regional municipal nordic eu au aau dtu itu sdu ruc cbs
  governance education data-infrastructure clinical nlp imaging succession
]).freeze

RELATIONS = Set.new([
  'Kind', 'Form', 'Status', 'Period', 'Date', 'Founded', 'As of',
  'Part of', 'Hosted by', 'Led by', 'Partners',
  'Governed by', 'Governs',
  'Title', 'Chair', 'Deputy chair', 'Director', 'Head', 'Deputy head', 'Co-lead', 'Secretariat', 'Member',
  'Members', 'Funded by', 'Awards', 'Volume', 'Instrument',
  'Succeeds', 'Succeeded by',
  'Convened by', 'Part of series', 'Venue',
  'Also known as', 'Web', 'Term length', 'Initiatives', 'Phases', 'Level', 'Offered by'
]).freeze

FOCUS_VIEWS = { 'ucph' => 'views/ucph/index.md', 'health' => 'views/health/index.md' }.freeze
concept_tags = {}

$t1 = []
$t2 = []
$warn = []
def t1(f, m) = $t1 << "#{f}: #{m}"
def t2(f, m) = $t2 << "#{f}: #{m}"
def warn_(f, m) = $warn << "#{f}: #{m}"

files = Dir.glob('**/*.md')
              .reject { |f| SKIP_DIRS.any? { |d| f.start_with?("#{d}/") } }
              .reject { |f| DOC_FILES.include?(f) }
              .sort
concepts = files.reject { |f| RESERVED.include?(File.basename(f)) }
indexes  = files.select { |f| File.basename(f) == 'index.md' }

# every path linked from an index.md, for the orphan check
linked_from_index = Set.new
indexes.each do |idx|
  read_utf8(idx).scan(/\]\(([^)\s#]+)\)/).flatten.each do |href|
    next if href.start_with?('http', 'mailto:')
    p = href.start_with?('/') ? href.sub(%r{\A/}, '') : File.expand_path(href, File.dirname(idx)).sub("#{ROOT}/", '')
    linked_from_index << p
  end
end

files.each do |f|
  body = read_utf8(f)
  base = File.basename(f)
  has_fm = body.start_with?("---\n")
  fm = nil
  fm_raw = nil

  if has_fm
    raw = body[4..].split("\n---\n", 2)
    if raw.length < 2
      t1(f, 'frontmatter block is not terminated by a "---" line')
      next
    end
    fm_raw = raw[0]
    begin
      fm = YAML.safe_load(raw[0], permitted_classes: [Date, Time])
    rescue StandardError => e
      t1(f, "frontmatter is not parseable YAML (#{e.class})")
      next
    end
    t1(f, 'frontmatter is not a mapping') unless fm.is_a?(Hash)
    body = raw[1]
  end

  # ---- reserved files (SPEC §6, §7) ----
  if RESERVED.include?(base)
    if base == 'index.md'
      if has_fm && f != 'index.md'
        t1(f, 'only the bundle-root index.md may carry frontmatter (SPEC §11)')
      elsif f == 'index.md'
        t1(f, 'root index.md must declare okf_version') unless fm.is_a?(Hash) && fm['okf_version']
      end
    elsif base == 'log.md'
      t1(f, 'log.md must have no frontmatter') if has_fm
      t2(f, 'log.md has no "## YYYY-MM-DD" entry headings') unless body =~ /^## \d{4}-\d{2}-\d{2}/
    end
    next
  end

  # ---- Tier 1: every concept needs parseable frontmatter with a non-empty type ----
  unless has_fm
    t1(f, 'concept file has no YAML frontmatter')
    next
  end
  next unless fm.is_a?(Hash)
  if fm['type'].nil? || fm['type'].to_s.strip.empty?
    t1(f, 'frontmatter has no non-empty "type"')
  end

  # ---- Tier 2: local policy ----
  t2(f, 'concept files are not allowed under views/ — views hold index.md only') if f.start_with?('views/')

  (fm.keys - ALLOWED_KEYS).each { |k| t2(f, "frontmatter key \"#{k}\" is outside the closed set (#{ALLOWED_KEYS.join(', ')})") }
  %w[title description resource].each { |k| t2(f, "missing \"#{k}\"") if fm[k].to_s.strip.empty? }

  # Validate the timestamp as written: YAML silently coerces a date-like scalar to
  # Time, so fm['timestamp'] can no longer tell us what the file actually says.
  ts_raw = fm_raw[/^timestamp:[ \t]*(.+?)[ \t]*$/, 1]
  if fm['timestamp'].nil?
    t2(f, 'missing "timestamp"')
  elsif ts_raw !~ /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?(Z|[+-]\d{2}:?\d{2})\z/
    t2(f, "timestamp \"#{ts_raw}\" is not an ISO 8601 datetime (want e.g. 2026-09-21T00:00:00Z)")
  else
    parsed = Time.iso8601(ts_raw)
    if parsed < Time.now - 31_536_000
      warn_(f, "timestamp is #{((Time.now - parsed) / 31_536_000).round(1)} years old — due a verification pass")
    end
  end

  top = f.split('/').first
  if (expected = FOLDER_TYPES[top]) && fm['type'] != expected
    t2(f, "folder/type mismatch: #{top}/ requires type \"#{expected}\", found \"#{fm['type']}\"")
  end

  tags = fm['tags']
  concept_tags[f] = tags.map(&:to_s) if tags.is_a?(Array)
  if !tags.is_a?(Array) || tags.empty?
    t2(f, 'missing or empty "tags"')
  else
    tags.each { |tag| t2(f, "tag \"#{tag}\" is outside the vocabulary in CLAUDE.md §8") unless TAGS.include?(tag.to_s) }
    t2(f, "#{tags.length} tags — CLAUDE.md §8 allows at most 5") if tags.length > 5
    warn_(f, 'first tag is not the class tag (CLAUDE.md §8 fixes the order)') if tags.first.to_s != fm['type'].to_s.downcase.split.first.sub('governance', 'body')
  end

  t2(f, 'no "# Citations" section') unless body =~ /^# Citations$/

  # Relation vocabulary (CLAUDE.md §7) governs the left column of a *headerless*
  # two-column table — the "| | |" / "|---|---|" idiom. Labelled tables such as
  # "| Collaboratory | Leads |" or "| Seat | Holder | Term |" are ordinary data and
  # are deliberately not checked.
  body.scan(/^\|[ \t]*\|[ \t]*\|[ \t]*\n\|[-| \t]+\|[ \t]*\n((?:\|.*\n)+)/).flatten.each do |block|
    block.each_line do |row|
      label = row[/\A\| ([^|]+?) \|/, 1]
      next if label.nil? || RELATIONS.include?(label.strip)
      warn_(f, "relation label \"#{label.strip}\" is outside the closed vocabulary in CLAUDE.md §7")
    end
  end
end

# ---- link graph (Tier 2: SPEC §5.3 tolerates broken links; local policy does not) ----
files.each do |f|
  read_utf8(f).scan(/\]\(([^)\s]+)\)/).flatten.each do |href|
    next if href.start_with?('http', 'mailto:', '#')
    path, = href.split('#', 2)
    next if path.empty?
    target = path.start_with?('/') ? path.sub(%r{\A/}, '') : File.expand_path(path, File.dirname(f)).sub("#{ROOT}/", '')
    t2(f, "dangling link -> #{href}") unless File.exist?(target)
  end
end

# ---- every concept must be listed in its OWN directory's index.md ----
# Stronger than "linked from any index.md": a concept can appear in a view and still be
# missing from its class index, which is the canonical listing for its directory (SPEC §6).
# That exact gap went unnoticed for several passes, which is why this check exists.
concepts.each do |f|
  own = File.join(File.dirname(f), 'index.md')
  listed_here = File.exist?(own) && read_utf8(own).scan(/\]\(([^)\s#]+)\)/).flatten.any? do |href|
    next false if href.start_with?('http', 'mailto:')
    t = href.start_with?('/') ? href.sub(%r{\A/}, '') : File.expand_path(href, File.dirname(own)).sub("#{ROOT}/", '')
    t == f
  end
  unless listed_here
    where = linked_from_index.include?(f) ? ' (it is linked from another index, which hides the gap)' : ''
    warn_(f, "not listed in its own directory index #{own}#{where}")
  end
end

# ---- focus views must cover every concept carrying their focus tag ----
# The foci are expressed as tags plus views rather than as folders (CLAUDE.md §4),
# so a tagged-but-unlisted concept is invisible in the view that is supposed to be
# the whole answer to that focus.
FOCUS_VIEWS.each do |tag, view|
  next unless File.exist?(view)
  listed = Set.new
  read_utf8(view).scan(/\]\(([^)\s#]+)\)/).flatten.each do |href|
    next if href.start_with?('http', 'mailto:')
    p = href.start_with?('/') ? href.sub(%r{\A/}, '') : File.expand_path(href, File.dirname(view)).sub("#{ROOT}/", '')
    listed << p
  end
  concept_tags.each do |f, tags|
    next unless tags.include?(tag)
    warn_(view, "concept tagged \"#{tag}\" but not listed in this view: #{f}") unless listed.include?(f)
  end
end

puts "DK-AI linter — #{concepts.length} concepts, #{indexes.length} indexes\n\n"
if $t1.empty?
  puts "Tier 1 (OKF conformance): PASS"
else
  puts "Tier 1 (OKF conformance) — #{$t1.length} VIOLATION(S):"
  $t1.each { |m| puts "  x #{m}" }
end
puts
if $t2.empty?
  puts "Tier 2 (local policy): PASS"
else
  puts "Tier 2 (local policy) — #{$t2.length} failure(s). These are house rules, not OKF non-conformance:"
  $t2.each { |m| puts "  ! #{m}" }
end
unless $warn.empty?
  puts "\nWarnings — #{$warn.length}#{SHOW_WARNINGS ? '' : ' (run with --warnings to list)'}:"
  $warn.each { |m| puts "  ~ #{m}" } if SHOW_WARNINGS
end

exit($t1.empty? && $t2.empty? ? 0 : 1)
