# frozen_string_literal: true

require_relative "string-text/version"

module String::Text
  class Error < StandardError; end
  
  refine String do
    # Indent or outdent a block of text to the given column. It uses the indent
    # of the non-empty line as the indent of the whole block that is then
    # adjusted as a whole (including internal indents) to the given column
    #
    # It is often handy when you're calling methods with a %(...) argument:
    #
    #   some_method %(
    #     This will start at column 1
    #       This will start at column 3
    #   ).adjust
    #
    def adjust(column = 1)
      column == 1 or raise NotImplementedError
      lines = self.split(/\n/)
      lines.shift while !lines.empty? && !(lines.first =~ /^(\s*)\S/)
      return "" if lines.empty?
      indent = $1.size
      r = []
      while line = lines.shift&.rstrip
        r << (line[indent..-1] || "")
      end
      while !r.empty? && r.last =~ /^\s*$/
        r.pop
      end
      r.join("\n").chomp
    end

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

