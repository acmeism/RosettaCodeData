if {[catch {fconfigure stdin -mode}]} {
    puts "Input doesn't come from tty."
} else {
    puts "Input comes from tty."
}
