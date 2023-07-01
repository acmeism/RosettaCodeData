proc ordinal-of-alpha {c} {                     ;#  returns ordinal position of c in the alphabet (A=1, B=2...)
    lsearch {_ A B C D E F G H I J K L M N O P Q R S T U V W X Y Z} [string toupper $c]
}

proc Cusip-Check-Digit {cusip} {                ;# algorithm Cusip-Check-Digit(cusip) is
    if {[string length $cusip] != 8} {          ;#    Input: an 8-character CUSIP
        return false
    }

    set sum 0                                   ;#    sum := 0
    for {set i 1} {$i <= 8} {incr i} {          ;#    for 1 ≤ i ≤ 8 do
        set c [string index $cusip $i-1]        ;#       c := the ith character of cusip
        if {[string is digit $c]} {             ;#       if c is a digit then
            set v $c                            ;#          v := numeric value of the digit c
        } elseif {[string is alpha $c]} {       ;#       else if c is a letter then
            set p [ordinal-of-alpha $c]         ;#          p := ordinal position of c in the alphabet (A=1, B=2...)
            set v [expr {$p + 9}]               ;#          v := p + 9
        } elseif {$c eq "*"} {                  ;#       else if c = "*" then
            set v 36                            ;#          v := 36
        } elseif {$c eq "@"} {                  ;#       else if c = "@" then
            set v 37                            ;#          v := 37
        } elseif {$c eq "#"} {                  ;#       else if c = "#" then
            set v 38                            ;#          v := 38
        }                                       ;#       end if
        if {$i % 2 == 0} {                      ;#       if i is even then
            set v [expr {$v * 2}]               ;#          v := v × 2
        }                                       ;#       end if

        incr sum [expr {$v / 10 + $v % 10}]     ;#       sum := sum + int ( v div 10 ) + v mod 10
    }                                           ;#    repeat

    expr {(10 - ($sum % 10)) % 10}              ;#    return (10 - (sum mod 10)) mod 10
}
proc check-cusip {cusip} {
    set last  [string index $cusip end]
    set cusip [string range $cusip 0 end-1]
    expr {$last eq [Cusip-Check-Digit $cusip]}
}
