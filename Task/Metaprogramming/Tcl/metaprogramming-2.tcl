loopVar x from 1 to 4 {
    loopVar y from $x to 6 {
        puts "pair is ($x,$y)"
        if {$y >= 4} break
    }
}
