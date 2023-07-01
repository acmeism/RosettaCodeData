proc loop {varName from to body} {
    upvar 1 $varName var
    for {set var $from} {$var <= $to} {incr var} {
        uplevel 1 $body
    }
}

loop x 1 10 {
    puts "x is now $x"
    if {$x == 5} {
        puts "breaking out..."
        break
    }
}
puts "done"
