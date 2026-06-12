#!/bin/sh

# Insert shell code here!
printf '%s\n' "Shell running $0"
i=1
for arg do
  printf '  %s\n' "\${$i}: $arg"
  i=`expr $i + 1`
done

# Switch from shell to Ruby.
exec ${RUBY-ruby} -x "$0" --coming-from-sh "$@"

#!ruby

ARGV[0] == "--coming-from-sh" or exec "/bin/sh", $0, *ARGV
ARGV.shift

# Insert Ruby code here!
puts "Ruby running #$0"
ARGV.each_with_index do |arg, i|
  puts "  ARGV[#{i}]: #{arg}"
end
