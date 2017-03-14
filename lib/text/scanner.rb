require "text/scanner/version"

module Text
  class Scanner

    # create a new +Text::Scanner+ object on +input+, which can be a string of
    # literal text to scan, or an IO stream object, responding to +gets+.

    def self.scan(input)
      new(input)
    end

    # create a +Text::Scanner+ object on +file+, which *must* be an IO
    # stream object.

    def self.scan_file(file)
      new(file.respond_to?(:gets) ? file : File.open(file))
    end

    # same as +scan+.

    def initialize(input)
      @input = input.respond_to?(:gets) ? input : StringIO.new(input, 'r')
      @path  = input.respond_to?(:path) ? input.path : nil
      reset
    end

    # the path name for the file object, or +nil+
    attr_reader :path

    # the most recent text obtained via +gets+
    attr_reader :last_text

    # resets any pushed-back text, and rewinds the IO stream (if possible).
    #
    def reset
      @next_text = []
      @last_text = nil
      @input.rewind if @input.respond_to?(:rewind)
    end

    # returns the next input line, whether from any pushed-back text, or from
    # the input stream.

    def gets
      @last_text = @next_text.shift || @input.gets
    end

    alias_method :read_line, :gets

    # pushes +text+ back into the input stream.  If +text+ not given,
    # pushes the previously fetched input (from +last_text+).

    def ungets(text=nil)
      new_text = text || get_last_text
      @next_text.unshift(new_text) unless new_text.nil?
      new_text
    end

    alias_method :put_line, :ungets
    alias_method :put_text, :ungets

    # skip lines until one matches +pat+
    # The _next_ line read (via +gets+) reads the matching line.

    def skip_until(pat)
      skip_while_do {|line| !pat.match(line)}
    end

    # skip lines matching +pat+.  The _next_ line after will match +pat+.

    def skip_while(pat)
      skip_while_do {|line| pat.match(line)}
    end

    # scan lines with +match+ = +pat+.+match+(+line+), invoking +block+(+line+, +match+)

    def scan_while(pat, &block)
      scan_while_do(block) {|line| pat.match(line) }
    end

    # process each line matching +pat+, invoking +block+(+line+)

    def each_while(pat, &block)
      each_while_do(block) {|line| pat.match(line) }
    end

    # process lines matching +pat+, returning an array of the return values from
    # invoking +block+(+line+, +match+).

    def map_while(pat)
      result = []
      scan_while(pat) do |line, match|
        result << yield(line, match)
      end
      result
    end

    # process each line _not_-matching +pat+, invoking +block+(+line+)

    def each_until(pat, &block)
      each_while_do(block) {|line| !pat.match(line) }
    end

    # iterate over each line with a block

    def each
      while (line = gets) do
        yield(line)
      end
    end

    # iterate over each line, returning an array of results

    def map
      result = []
      while (line = gets) do
        result << yield(line)
      end
      result
    end


    # :stopdoc:

    private

    def skip_while_do
      while (line = gets) do
        unless yield(line)
          ungets
          break
        end
      end
    end

    def scan_while_do(do_block)
      while (line = gets) do
        if (result = yield(line))
          do_block.call(line, result)
        else
          ungets
          break
        end
      end
    end

    def each_while_do(do_block)
      while (line = gets) do
        if yield(line)
          do_block.call(line)
        else
          ungets
          break
        end
      end
    end

    def get_last_text
      last_text, @last_text = @last_text, nil
      last_text
    end

  end
end
