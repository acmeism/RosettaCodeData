#!/usr/bin/env tclsh
#

package require generator   ;# from tcllib

namespace eval stern-brocot {
    proc generate {{count 100}} {
        set seq {1 1}
        set n 0
        while {[llength $seq] < $count} {
            lassign [lrange $seq $n $n+1] a b
            lappend seq [expr {$a + $b}] $b
            incr n
        }
        return $seq
    }

    proc genr {} {
        yield [info coroutine]
        set seq {1 1}
        while {1} {
            set seq [lassign $seq a]
            set b [lindex $seq 0]
            set c [expr {$a + $b}]
            lappend seq $c $b
            yield $a
        }
    }

    proc Step {a b args} {
        set c [expr {$a + $b}]
        list $a [list $b {*}$args $c $b]
    }

    generator define gen {} {
        set cmd [list 1 1]
        while {1} {
            lassign [Step {*}$cmd] a cmd
            generator yield $a
        }
    }

    namespace export {[a-z]*}
    namespace ensemble create
}

interp alias {} sb {} stern-brocot

# a simple adaptation of gcd from http://wiki.tcl.tk/2891
proc coprime {a args} {
    set gcd $a
    foreach arg $args {
        while {$arg != 0} {
            set t $arg
            set arg [expr {$gcd % $arg}]
            set gcd $t
            if {$gcd == 1} {return true}
        }
    }
    return false
}

proc main {} {

    puts "#1. First 15 members of the Stern-Brocot sequence:"
    puts \t[generator to list [generator take 16 [sb gen]]]

    puts "#2. First occurrences of 1 through 10:"
    set first {}
    set got 0
    set i 0
    generator foreach x [sb gen] {
        incr i
        if {$x>10} continue
        if {[dict exists $first $x]} continue
        dict set first $x $i
        if {[incr got] >= 10} break
    }
    foreach {a b} [lsort -integer -stride 2 $first] {
        puts "\tFirst $a at $b"
    }

    puts "#3. First occurrence of 100:"
    set i 0
    generator foreach x [sb gen] {
        incr i
        if {$x eq 100} break
    }
    puts "\tFirst $x at $i"

    puts "#4. Check first 1k elements for common divisors:"
    set prev [expr {2*3*5*7*11*13*17*19+1}] ;# a handy prime
    set i 0
    generator foreach x [sb gen] {
        if {[incr i] >= 1000} break
        if {![coprime $x $prev]} {
            error "Element $i, $x is not coprime with $prev!"
        }
        set prev $x
    }
    puts "\tFirst $i elements are all pairwise coprime"
}

main
