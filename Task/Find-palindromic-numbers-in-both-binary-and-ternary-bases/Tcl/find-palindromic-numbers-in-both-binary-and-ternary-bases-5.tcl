proc task {{find 6}} {
    coroutine gen apply {{} {yield; 2pals}}
    while {$find} {
        set b [gen]
        set i [scan $b %b]
        set t [format_%t $i]
        if {[pal? $t]} {
            puts "Palindrome: $i ($b) ($t)"
            incr find -1
        }
    }
    rename gen {}
}

puts [time task]
