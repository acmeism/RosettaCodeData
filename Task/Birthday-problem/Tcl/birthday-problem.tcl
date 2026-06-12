proc birthdays {num {same 2}} {
    for {set i 0} {$i < $num} {incr i} {
	set b [expr {int(rand() * 365)}]
	if {[incr bs($b)] >= $same} {
	    return 1
	}
    }
    return 0
}

proc estimateBirthdayChance {num same} {
    # Gives a reasonably close estimate with minimal execution time; the idea
    # is to keep the amount that one random value may influence the result
    # fairly constant.
    set count [expr {$num * 100 / $same}]
    set x 0
    for {set i 0} {$i < $count} {incr i} {
	incr x [birthdays $num $same]
    }
    return [expr {double($x) / $count}]
}

foreach {count from to} {2 20 25 3 85 90 4 183 190 5 310 315} {
    puts "identifying level for $count people with same birthday"
    for {set i $from} {$i <= $to} {incr i} {
	set chance [estimateBirthdayChance $i $count]
	puts [format "%d people => %%%.2f chance of %d people with same birthday" \
		  $i [expr {$chance * 100}] $count]
	if {$chance >= 0.5} {
	    puts "level found: $i people"
	    break
	}
    }
}
