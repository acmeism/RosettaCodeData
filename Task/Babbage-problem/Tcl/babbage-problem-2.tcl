# The last k digits of a square x**2 are determined by the last k digits of
## the number x, and independent of all higher digits.
## We search for possible endings (suffixes) of x from the right, and extend
## by one digit in each step.  That way we think to have an algorithm,
## which scales very well to really long suffixes.
## Also, when there is no solution, we detect that and terminate orderly.

namespace path {::tcl::mathop}          ;# commands like: + - *

interp alias {}  LEN    {} string length

##      Normalize a string (of digits) as (decimal) number.
##      Tcl still thinks, numbers starting with "0" are meant octal (base 8).
##      We do not even have a qualifying prefix like "0d".
##      Here we just handle such leading zeroes.
proc normNumber {str} {
    set str [string trimleft $str 0]    ;# drop all leading zeroes
    if {$str eq ""} {                   ;# if string is completely empty
        set str "0"                     ;# we leave a single zero digit
    }
    return $str
}

##      If possible, cuts off some left part of $str to yield a suffix
##      of at most length $wantlen.
proc cutSuff {str wantlen} {
    set havelen [LEN $str]
    set toskip [- $havelen $wantlen]
    return [string range $str $toskip end]      ;# treats negative $toskip as 0
}

##      We have some numeric suffix string $str, and we need it for
##      the specified length $wantlen, either by taking a shorter suffix,
##      or by filling up with zeroes at the left.
proc numToExactSuffLen {str wantlen} {
    set havelen [LEN $str]
    if {$havelen > $wantlen} {                  ;# cut down in length
        set toskip [expr {$havelen - $wantlen}]
        return [string range $str $toskip end]
    } elseif {$havelen < $wantlen} {            ;# pad zeroes at left end
        set topad [expr {$wantlen - $havelen}]
        return "[string repeat "0" $topad]$str"
    }
    return $str
}

##      Compute the square of a number, given as a string
proc stringSquare {str} {
    set numstr [normNumber $str]        ;# make proper number from string
    return [* $numstr $numstr]          ;# square the number
}

##      We search for a square that has suffix $totend.
##      So far we have constructed suffixes of some (small) length k,
##      which produce squares with a suitable suffix to match $totend
##      in the last k digits.  These suffixes are collected in list $sofar.
##      We compute the list of suffix candidates with length 1 greater.
proc nextList {totsuff sofar} {
    ## Determine the length $olen of the members in list $sofar.
    if {[llength $sofar]} {                     ;# has elements
        set olen [LEN [lindex $sofar 0]]        ;# check out first element
    } else {
        set olen 0                              ;# empty list
    }

    ## Determine $nlen, the new length we want to contruct suffixes for.
    set nlen [+ 1 $olen]                ;# we prepend 1 digit

    ## Determine the suffix we have to construct here, i.e.
    ## $totsuff reduced to the length we construct, here.
    if {$nlen <= [LEN $totsuff]} {
        set wantsuff [cutSuff $totsuff $nlen]
    } else {
        ## We do not have enough input (from $totsuff) to further limit
        ## the squares of constructed numbers.  All possible left
        ## extensions will do.  This can happen e.g. for $totsuff = ""
        set wantsuff $totsuff           ;# that all we need to match
    }
    set wantlen [LEN $wantsuff]

    ## We are going to construct all suffixes one longer as those
    ## in list $sofar, by prepending all decimal digits.
    set res {}                  ;# resulting list of new suffixes
    foreach d {0 1 2 3 4 5 6 7 8 9} {
        foreach e $sofar {
            set cand $d$e
            ## Now we need to know the ending of the square of $cand,
            ## We take care that $cand may be not noprmalized.
            set sq [stringSquare $cand]         ;# square it
            incr ::didSqs                       ;# count this squaring

            ## Check for a solution for our new suffix list
            if {$wantsuff eq [numToExactSuffLen $sq $wantlen]} {
                lappend res $cand
            }

            ## Check for a solution for the final job: the suffix of $sq
            ## must match, and $cand must be a positive number.
            if {[string match *$totsuff $sq] && ($d > 0)} {
                lappend ::sols $cand
                puts "(sol after $::didSqs squarings: $cand)"
            }
        }
    }
    return $res
}

set ::didSqs 0                  ;# count squarings

proc searchSquareSuff {totsuff} {
    set ::sols {}                       ;# not yet collected any solution
    set sufflist [list ""]              ;# just the empty suffix: 1-elem list
    set maxsufflen [+ 1 [LEN $totsuff]]
    for {set sufflen 1} {$sufflen <= $maxsufflen} {incr sufflen} {
        set sufflist [ nextList $totsuff $sufflist ]
        set elems [llength $sufflist]
        if {0 == $elems} {
            break
        }
        if {[llength $::sols]} {
            set sol [normNumber [lindex $::sols 0]]
            puts ""
            puts "Smallest number with suffix $totsuff is $sol"
            puts " since its square is [* $sol $sol]."
            if {1 < [llength $::sols]} {
                puts "More solutions: [lrange $::sols 1 end]"
            }
            break
        }
        ## Without any solution so far, we show the suffix list.
        ## It is the basis for further computations, and could be checked.
        puts "  List of suffixes of length $sufflen has $elems elements:"
        puts "    {$sufflist}"
    }
    if {![llength $::sols]} {
        puts ""
        puts "No solution for $totsuff"
    }
}

if {[llength $::argv]} {
    foreach a $::argv {
        searchSquareSuff $a
    }
} else {
    searchSquareSuff 269696
}
puts "(did $::didSqs squarings upto now)"
## You may want to try 08315917380318501319044 for solution 9999999156746824862
