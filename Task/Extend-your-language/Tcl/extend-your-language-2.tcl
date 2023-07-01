if2 {1 > 0} {"grill" in {foo bar boo}} {
    puts "1 and 2"
} {
    puts "1 but not 2"
} {
    puts "2 but not 1"
} {
    puts "neither 1 nor 2"
}
