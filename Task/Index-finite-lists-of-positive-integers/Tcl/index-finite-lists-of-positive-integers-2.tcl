set s {1 2 3 10 100 987654321 135792468107264516704251 7}
puts "prior: $s"
set c [rank $s]
puts "encoded: $c"
set t [unrank $c]
puts "after: $t"
