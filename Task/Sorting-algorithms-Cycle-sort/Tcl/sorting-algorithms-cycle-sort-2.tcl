set example {0 1 2 2 2 2 1 9 3.5 5 8 4 7 0 6}
puts "Data was: $example"
set writes [cycleSort example]
puts "Data is now: $example"
if {$example eq [lsort -real $example]} {
    puts "\twhich is correctly sorted"
} else {
    puts "\twhich is the wrong order!"
}
puts "Writes required: $writes"
