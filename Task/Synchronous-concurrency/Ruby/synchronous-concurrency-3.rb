require 'continuation' unless defined? Continuation

count = 0
reader = proc do |cont|
  IO.foreach("input.txt") { |line| cont = callcc { |cc| cont[cc, line] }}
  puts "Printed #{count} lines."
  cont[nil]
end

# printer
while array = callcc { |cc| reader[cc] }
  reader, line = array
  print line
  count += 1
end
