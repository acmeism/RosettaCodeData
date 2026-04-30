# an accumulator (acc) collects letters
proc reverse_rec { n str {acc ""} } {

    # termination condition
    if {$n eq 0} {return $acc}

    set head [string index $str 0]
    set tail [string range $str 1 end]

    # tail recursive call replaces execution frame
    tailcall reverse_rec [expr {$n-1}] $tail "${head}${acc}"
}

#  calls reverse_rec /w initial params
proc reverse {s} {
    set n [string length $s]
    return [reverse_rec $n  $s ""]
}

set s "doggy"
set t [reverse $s]
puts "$s\t $t"
