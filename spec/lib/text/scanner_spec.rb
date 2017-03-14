require 'text/scanner.rb'

RSpec.describe Text::Scanner, "#new" do

  Line_One   = "This is a string\n".freeze
  Line_Two   = "This is another string\n".freeze
  Line_Three = "This is the third line text\n".freeze

  context "with a string input" do

    let(:test_input) { Line_One + Line_Two }
    let(:scanner)    { Text::Scanner.new(test_input) }

    it "creates a scanner object using the string input" do
      expect(scanner).to be_instance_of Text::Scanner
    end

    it "reads lines, one at a time correctly" do
      expect(scanner.gets).to eq(Line_One)
      expect(scanner.gets).to eq(Line_Two)
    end

    it "can unread text" do
      expect(scanner.gets).to eq(Line_One)
      expect(scanner.ungets).to eq(Line_One)
      expect(scanner.gets).to eq(Line_One)
    end

    it "has a nil path" do
      expect(scanner.path).to be_nil
    end

    it "using #ungets, it can push back multiple lines of text" do
      expect(scanner.ungets('foo')).to eq('foo')
      expect(scanner.ungets('bar')).to eq('bar')
      expect(scanner.gets).to eq('bar')
      expect(scanner.gets).to eq('foo')
      expect(scanner.gets).to eq(Line_One)
    end
  end

  context "with a file object" do
    test_filename = "/tmp/#$$.testfile.txt"

    before(:all) do
      File.open(test_filename, 'w+') do |file|
        file.write (<<EOF)
#{Line_One.chomp}
#{Line_Two.chomp}
2016/10/28 [app] Error thingy
#{Line_Three.chomp}
2016/11/07 [app] Error thingy too
EOF
      end
    end

    let(:scanner) { Text::Scanner.scan_file(test_filename) }
    let(:date_re) { %r{^\d{4}/\d{1,2}/\d{1,2}\b} }

    it "creates a scanner object on the file input" do
      expect(scanner).to be_instance_of Text::Scanner
      expect(scanner.path).to eq(test_filename)
    end

    it "has a path matching the original file path" do
      expect(scanner.path).to eq(test_filename)
    end

    it "reads lines, one at a time correctly" do
      expect(scanner.gets).to eq(Line_One)
      expect(scanner.gets).to eq(Line_Two)
    end

    it "can skip lines until matching a pattern" do
      expect {scanner.skip_until(date_re)}.not_to raise_error
      expect(scanner.gets).to match(date_re)
      expect(scanner.gets).to eq(Line_Three)
    end

    it "can skip lines while matching a pattern" do
      expect(scanner.skip_while(/^This is/)).not_to match(/Line_One|Line_Two/)
      expect(scanner.gets).to match(date_re)
      expect(scanner.gets).to eq(Line_Three)
    end

    it "can scan and process lines matching a pattern, passing line and result arguments" do
      matching_lines = 0
      scanner.scan_while(/^This is (.*)$/) do |line, match|
        expect(match[0]).to match(/(?:a|another) string/)
        matching_lines += 1
      end
      expect(matching_lines).to eq(2)
    end

    it "can scan and process lines matching a pattern, passing only the line argument" do
      matching_lines = 0
      scanner.scan_while(/^This is /) do |line|
        matching_lines += 1
      end
      expect(matching_lines).to eq(2)
    end

    it "can scan lines until a pattern occurs" do
      matching_lines = 0
      scanner.each_until(date_re) do |line|
        matching_lines += 1
      end
      expect(matching_lines).to eq(2)
    end

    it "can map the results of lines matching a pattern" do
      lines = scanner.map_while(/^(This)/) {|line, match| match[1]}
      expect(lines.size).to eq(2)
      expect(lines.uniq).to eq(['This'])
    end
  end

end
