foreach d [deranged1to 4] {
    puts "derangement of 1..4: $d"
}

puts "\n\tcounted\tcalculated"
for {set i 0} {$i <= 9} {incr i} {
    puts "!$i\t[countDeranged1to $i]\t[subfact $i]"
}

# Stretch goal
puts "\n!20 = [subfact 20]"
