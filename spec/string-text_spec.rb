describe "String::Text" do
  using String::Text

  it 'has a version number' do
    expect(String::Text::VERSION).not_to be_nil
  end

  describe "#align" do
    context "when given a string w/o newlines" do
      it "removes initial indent" do
        expect("  text".align).to eq "text"
      end
      it "does nothing if the line is not indented" do
        expect("text".align).to eq "text"
      end
      it "removes final whitespace" do
        expect("text  ".align).to eq "text"
      end
    end
    context "when given a multiline string" do
      it "ignores initial empty lines" do
        expect("\n\ntext".align).to eq "text"
      end
      it "does not remove initial indent if first line is not indented" do
        expect("level0\n  level1".align).to eq "level0\n  level1"
      end
      it "only realigns if the first line is not indented" do
        expect("level0\n  level1".align(3)).to eq "  level0\n    level1"
      end
      it "realigns lines starting at column 1" do
        a = %w(hello world)
        text = %(
          before
            #{a.join("\n")}
          after
        )
        expected = %(
          before
            hello
            world
          after
        )
        expect(text.align).to eq expected.align
      end
      it "removes the initial indent for all lines" do
        expect("\n  text".align).to eq "text"
      end
      it "uses the indent of the least indented line as the block indent" do
        expect("    line1\n  line2\n".align).to eq "  line1\nline2"
      end
      it "removes the initial indent from the first line" do
        expect("\n  text".align).to eq "text"
      end
      it "removes the initial indent from the remaining lines" do
        expect("  line1\n    line2\n".align).to eq "line1\n  line2"
      end
      it "removes final blanks from all lines" do
        expect("  line1\n    \n    line2\n".align).to eq "line1\n\n  line2"
      end
      it "internal empty lines are not indented" do
        expect("  line1\n    \n    line2\n".align).to eq "line1\n\n  line2"
      end
      it "removes final whitespace or newline" do
        expect("text  ".align).to eq "text"
        expect("text  \n".align).to eq "text"
        expect("line1  \nline2  \n".align).to eq "line1\nline2"
      end
      it "handles empty lines" do
        expect("  text\n\n    text".align).to eq "text\n\n  text"
      end
    end
    context "when column != 1" do
      it "indents the text to the given column" do
        expect("  text\n\n    text".align(3)).to eq "  text\n\n    text"
      end
    end
    context "when :bol is false" do
      it "do not align the first line" do
        inner_text = %(
          inner line 1
          inner line 2
        )
        outer_text = %(
          outer line 1
            #{inner_text.align(13, bol: false)}
          outer line 2
        )
        expected = %(
          outer line 1
            inner line 1
            inner line 2
          outer line 2
        )
        expect(outer_text.align).to eq expected.align
      end
    end
  end

  describe "#align!" do
    it "replaces the value of the current string" do
      s = "  text"
      s.align!
      expect(s).to eq "text"
    end
  end

  describe "#to_b" do
    it "translates 'true' to true" do
      expect("true".to_b).to eq true
    end
    it "translates 'false' to false" do
      expect("false".to_b).to eq false
    end
    it "translates the empty string to false" do
      expect("".to_b).to eq false
    end
    it "raises otherwise" do
      expect { "hello".to_b }.to raise_error ArgumentError
    end
  end
end
