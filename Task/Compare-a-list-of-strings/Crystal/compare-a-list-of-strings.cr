def all_equal? (strings)
  strings.all? {|elt| elt == strings[0] }
end

def ascending? (strings)
  strings.each.cons_pair.all? {|a, b| a < b }
end

puts "strings   all_equal? ascending?"
puts "-------------------------------"
["a a a a", "", "a", "a b c", "a c a"].each do |s|
  ss = s.split
  printf "%-10s   %-5s    %-5s\n", "["+ss.join(" ")+"]", all_equal?(ss), ascending?(ss)
end
