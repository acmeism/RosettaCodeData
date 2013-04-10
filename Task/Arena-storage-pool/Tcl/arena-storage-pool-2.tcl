Pool create PoolExample {
    variable int

    method Init value {
	puts stderr "Initializing [self] with $value"
	set int $value
	incr int 0
    }
    method Finalize {} {
	puts stderr "Finalizing [self] which held $int"
    }

    method value {{newValue {}}} {
	if {[llength [info level 0]] == 3} {
	    set int [incr newValue 0]
	} else {
	    return $int
	}
    }
}

PoolExample capacity 10
set objs {}
try {
    for {set i 0} {$i < 20} {incr i} {
	lappend objs [PoolExample new $i]
    }
} trap {POOL CAPACITY} msg {
    puts "trapped: $msg"
}
puts -nonewline "number of objects: [llength $objs]\n\t"
foreach o $objs {
    puts -nonewline "[$o value] "
}
puts ""
set objs [lassign $objs a b c]
$a destroy
$b destroy
$c destroy
PoolExample capacity 9
try {
    for {} {$i < 20} {incr i} {
	lappend objs [PoolExample new $i]
    }
} trap {POOL CAPACITY} msg {
    puts "trapped: $msg"
}
puts -nonewline "number of objects: [llength $objs]\n\t"
foreach o $objs {
    puts -nonewline "[$o value] "
}
puts ""
PoolExample clearPool
