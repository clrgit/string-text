# frozen_string_literal: true

require_relative "string-text/version"

module String::Text
  class Error < StandardError; end

  refine String do
    # Indent or outdent a block of text to the given column (default 1). It
    # uses the indent of the least indented non-empty line as the indent of the
    # whole block that is then aligned as a whole (including internal indents)
    # to the given column. Initial and final empty lines are ignored
    #
    # #align is often handy when you call methods with a %(...) argument
    # and don't want weird indentation in your output
    #
    #   puts %(
    #     This line will start at column 1
    #       This line will start at column 3
    #   ).align
    #
    def align(column = 1)
      column > 0 or raise ArgumentError "Illegal column: #{column}"
      initial = " " * (column - 1)
      lines = self.split(/\n/)
      lines.pop while !lines.empty? && !(lines.last =~ /^\s*\S/)
      lines.shift while !lines.empty? && !(lines.first =~ /^\s*\S/)
      return "" if lines.empty?
      indent = lines.map { _1 =~ /^(\s*)/; $1.size }.select { _1 > 0 }.min || 0
      lines.map { |line|
        l = line[indent..-1]&.rstrip
        l ? initial + l : ""
      }.join("\n")
    end

    # Like #align but replaces the string
    def align!(column = 1) = self.replace align(column)

    # Converts a string to a boolean so that "true" becomes true and that
    # "false" and the empty string becomes false. Any other string is an error
    #
    def to_b
      case self
        when "true"; true
        when "false"; false
        when ""; false
      else
        raise ArgumentError, "Expected 'true', 'false', or the empty string, got: #{self.inspect}"
      end
    end
  end
end

