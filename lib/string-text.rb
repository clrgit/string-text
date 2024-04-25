# frozen_string_literal: true

require_relative "string-text/version"

module String::Text
  class Error < StandardError; end
  
  refine String do
    def undent
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

    # Converts a string to a boolean so that "true" becomes true and "false" and
    # the empty string becomes false. Should actually go in to a 
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

