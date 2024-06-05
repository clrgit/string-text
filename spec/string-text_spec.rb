describe "String::Text" do
  using String::Text

  it 'has a version number' do
    expect(String::Text::VERSION).not_to be_nil
  end

  describe "#adjust" do
    context "when given a string w/o newlines" do
      it "removes initial indent" do
        expect("  text".adjust).to eq "text"
      end
      it "removes final whitespace" do
        expect("text  ".adjust).to eq "text"
      end
    end
    context "when given a multiline string" do
      it "ignores initial empty lines" do
        expect("\n\ntext".adjust).to eq "text"
      end
      it "removes the initial indent from the first line" do
        expect("\n  text".adjust).to eq "text"
      end
      it "removes the initial indent from the remaining lines" do
        expect("  line1\n    line2\n".adjust).to eq "line1\n  line2"
      end
      it "removes final blanks from all lines" do
        expect("  line1\n    \n    line2\n".adjust).to eq "line1\n\n  line2"
      end
      it "internal empty lines are not indented" do
        expect("  line1\n    \n    line2\n".adjust).to eq "line1\n\n  line2"
      end
      it "removes final whitespace" do
        expect("text  \n".adjust).to eq "text"
        expect("line1  \nline2  \n".adjust).to eq "line1\nline2"
      end
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
