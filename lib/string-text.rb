# frozen_string_literal: true

require_relative "string-text/version"

module String::Text
  class Error < StandardError; end

  refine String do
    # Indent or outdent a block of text to the given column (default 1). It
    # uses the indent of the least indented non-empty line as the indent of the
    # block that is then aligned as a whole to the given column. Lines starting
    # at column one are realigned to the indent of the previous line. Initial
    # and final empty lines are ignored.
    #
    # #align is often handy when you call methods with a %(...) argument
    # and don't want weird indentation in your output
    #
    #   puts %(
    #     This line will start at column 1
    #       This line will start at column 3
    #   ).align
    #
    # Because unindented lines are realigned to the previous line's indent,
    # lists can be indented like this
    #
    #   words = %w(hello world)
    #   puts %(
    #     Array elements on separate lines and starting at column 3
    #       #{words.join("\n")}
    #   ).align
    #
    # If :bol is false then the first line won't be indented or outdented
    #
    def align(column = 1, bol: true)
      column > 0 or raise ArgumentError "Illegal column: #{column}"
      initial = " " * (column - 1)

      # Remove initial and final empty lines
      lines = self.split(/\n/).map &:rstrip
      lines.pop while !lines.empty? && !(lines.last =~ /^\s*\S/)
      lines.shift while !lines.empty? && !(lines.first =~ /^\s*\S/)
      return "" if lines.empty?

      # Find minimal indent. Ignores lines with indent 0
      indents = lines.map { _1 =~ /^(\s*)/; $1.size }
      indent = indents.select { _1 > 0 }.min || 0

      first = true
      lines.map.with_index { |line, i|
        if !bol && first
          first = false
          line[indents[0]..-1]
        else
          if line.empty?
            ""
          elsif indents[i] == 0 && i > 0 # Unindented lines
            indents[i] = indents[i-1] # use previous line's indent
            ' ' * (indents[i] - indent) + line
          else # Regular line
            initial + line[indent..-1]
          end
        end
      }.join("\n")
    end

    # Like #align but replaces the string
    def align!(column = 1, bol: true) = self.replace align(column, bol: bol)

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

