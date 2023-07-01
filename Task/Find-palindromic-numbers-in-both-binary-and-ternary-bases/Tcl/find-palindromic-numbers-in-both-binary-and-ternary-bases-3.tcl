proc task {{find 6}} {
    for {set i 0} {$find} {incr i} {
        set b [format %b $i]
        set t [format_%t $i]
        if {[pal? $b] && [pal? $t]} {
            puts "Palindrome: $i ($b) ($t)"
            incr find -1
        }
    }
}

puts [time {task 4}]
