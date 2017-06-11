require 'thor'

module BundleOutdatedFormatter
  class CLI < Thor
    NAME_REGEXP      = /(\* )*(?<name>.+) \(/.freeze
    NEWEST_REGEXP    = /newest (?<newest>[\d\.]+)/.freeze
    INSTALLED_REGEXP = /installed (?<installed>[\d\.]+)/.freeze
    REQUESTED_REGEXP = /requested (?<requested>.+)\)/.freeze
    GROUPS_REGEXP    = /in groups "(?<groups>.+)"/.freeze

    MARKDOWN_HEADER = <<-EOS.freeze
| gem | newest | installed | requested | groups |
| --- | --- | --- | --- | --- |
    EOS

    default_command :output

    desc 'output', 'Format output of `bundle outdated`'
    option :format, type: :string, aliases: '-f', default: 'markdown'

    def output
      return if STDIN.tty?

      puts format_markdown(outdated_gems_in_stdin) if options[:format] == 'markdown'
    end

    private

    def outdated_gems_in_stdin
      outdated_gems = STDIN.each.to_a.map(&:strip).reject(&:empty?)

      outdated_gems.map! do |line|
        matched_name      = NAME_REGEXP.match(line)
        matched_newest    = NEWEST_REGEXP.match(line)
        matched_installed = INSTALLED_REGEXP.match(line)
        matched_requested = REQUESTED_REGEXP.match(line)
        matched_groups    = GROUPS_REGEXP.match(line)

        if matched_name.nil? && matched_newest.nil? && matched_installed.nil? && matched_requested.nil? && matched_groups.nil?
          nil
        else
          {
            name:      gem_text(matched_name, :name),
            newest:    gem_text(matched_newest, :newest),
            installed: gem_text(matched_installed, :installed),
            requested: gem_text(matched_requested, :requested),
            groups:    gem_text(matched_groups, :groups)
          }
        end
      end

      outdated_gems.compact
    end

    def gem_text(text, name)
      text ? text[name] : ''
    end

    def format_markdown(outdated_gems)
      outdated_gems.map! do |gem|
        "| #{[gem[:name], gem[:newest], gem[:installed], gem[:requested], gem[:groups]].join(' | ').strip} |"
      end

      MARKDOWN_HEADER + outdated_gems.join("\n")
    end
  end
end
