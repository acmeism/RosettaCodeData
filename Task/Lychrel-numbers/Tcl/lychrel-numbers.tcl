proc pal? {n} {
    expr {$n eq [string reverse $n]}
}

proc step {n} {
    set n_ [string reverse $n]
    set n_ [string trimleft $n_ 0]
    expr {$n + $n_}
}

proc lychrels {{max 10000} {iters 500}} {

    set lychrels {}     ;# true Lychrels
    set visited {}      ;# visited numbers for Related test
    set nRelated 0      ;# count of related numbers seen
    set pals {}         ;# palindromic Lychrels and related

    puts "Searching for Lychrel numbers in \[1,$max\]"
    puts "With a maximum of $iters iterations"

    for {set i 1} {$i <= $max} {incr i} {
        set n $i        ;# seed the sequence
        set seq {}      ;# but don't check the seed, nor remember it for the Related test
        for {set j 0} {$j < $iters} {incr j} {
            set n [step $n]
            dict set seq $n {}
            if {[dict exists $visited $n]} {
                incr nRelated
                if {[pal? $i]} {
                    lappend pals $i
                }
                break   ;# bail out if it's Related
            }
            if {[pal? $n]} {
                break   ;# bail out if it's a palindrome
            }
        }
        if {$j >= $iters} {    ;# the loop was exhausted: must be a Lychrel!
            if {[pal? $i]} {
                lappend pals $i
            }
            lappend lychrels $i
            set visited [dict merge $visited $seq]
        }
    }

    puts "[llength $lychrels] Lychrel numbers found:"
    puts $lychrels
    puts "Count of related numbers: $nRelated"
    puts "Palindromic Lychrel and related numbers: $pals"
}

lychrels
