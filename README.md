# Text::Scanner

Text::Scanner is a library to make it easy to scan text.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'text-scanner'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install text-scanner

## Usage

### Creating a new Scanner object:

    s = Text::Scanner.scan(INPUT)

Creates a new Scanner object, on _INPUT_, which is an `IO`
or `String` object.  If _INPUT_ is a string, it is treated as the source text
for the scanner object.

    s = Text::Scanner.scan_file(FILE)

Creates a new Scanner object, on _FILE_, which is an IO object or the string
path to a text file.  If FILE is a string path, the file object is opened
for the duration of the scan, and closed with `s.close`.

### Using Scanner objects:

The following instance methods are available on the `Text::Scanner` object `s`:

| Method | Purpose |
| ---------- | --------- |
| `s.gets` | get the next line of input |
| `s.ungets` | put back the most recent line of input |
| `s.read_line` | an alias for `gets` |
| `s.put_line`  | an alias for `ungets` |
| `s.put_text(TEXT)`  | put `TEXT` back into the input stream |
| `s.ungets(line)` | put back `line` as the next line of input |
| `s.each { |line| ... }` | iterate the block over each line |
| `s.map { |line| ... }` | process each line until _EOF_ returning an array of the iteration results |
| `s.skip_until(PAT)` | skip lines of input until line matches `PAT` |
| `s.skip_while(PAT)` | skip lines of input while line matches `PAT` |
| `s.skip_while_do { |line| EXPR }` | skip lines while EXPR is true |
| `s.scan_while(PAT) { |line, match| ... }` | process lines while each line matches `PAT` |
| `s.each_until(PAT) { |line| ... }` | process lines until a line matches `PAT` |
| `s.scan_while_do(proc) { |line| EXPR}` | invoke `proc.call(line)` while EXPR is true for each line |

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can
also run `bin/console` for an interactive prompt that will allow you to
experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/aks/text-scanner. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Author & Contributors

Author: **Alan K. Stebbens** \<aks@stebbens.org\>

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

