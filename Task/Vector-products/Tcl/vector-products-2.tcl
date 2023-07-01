set a {3 4 5}
set b {4 3 5}
set c {-5 -12 -13}
puts "a • b = [dot $a $b]"
puts "a x b = [cross $a $b]"
puts "a • b x c = [scalarTriple $a $b $c]"
puts "a x b x c = [vectorTriple $a $b $c]"
