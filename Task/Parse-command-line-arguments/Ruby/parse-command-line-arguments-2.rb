require 'optparse'

sflag = false
longflag = false
count = 0
percent = 50
fruit = nil

OptionParser.new do |opts|
  # Default banner is "Usage: #{opts.program_name} [options]".
  opts.banner += " [arguments...]"
  opts.separator "This demo prints the results of parsing the options."
  opts.version = "0.0.1"

  opts.on("-s", "Enable short flag") {sflag = true}
  opts.on("--long", "Enable long flag") {longflag = true}
  opts.on("-b", "--both", "Enable both -s and --long"
          ) {sflag = true; longflag = true}
  opts.on("-c", "--count", "Add 1 to count") {count += 1}

  # Argument must match a regular expression.
  opts.on("-p", "--percent PERCENT", /[0-9]+%?/i,
          "Percent [50%]") {|arg| percent = arg.to_i}

  # Argument must match a list of symbols.
  opts.on("-f", "--fruit FRUIT",
          [:apple, :banana, :orange, :pear],
          "Fruit (apple, banana, orange, pear)"
          ) {|arg| fruit = arg}

  begin
    # Parse and remove options from ARGV.
    opts.parse!
  rescue OptionParser::ParseError => error
    # Without this rescue, Ruby would print the stack trace
    # of the error. Instead, we want to show the error message,
    # suggest -h or --help, and exit 1.

    $stderr.puts error
    $stderr.puts "(-h or --help will show valid options)"
    exit 1
  end
end

print <<EOF
Short flag: #{sflag}
Long flag: #{longflag}
Count: #{count}
Percent: #{percent}%
Fruit: #{fruit}
Arguments: #{ARGV.inspect}
EOF
