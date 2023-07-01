catch {namespace delete test_almost_equal_string} ;# Start with a clean namespace

namespace eval test_almost_equal_string {
    package require Tcl 8.4 ;# ?Maybe earlier?
    array set yesno {1 Yes 0 No} ;# For nice output

    proc isClose {a b {prec 9}} {
        proc toCoeff {n prec} {
            set repr 40 ;# Chosen to be arbitrarily large to handle most cases
            set long [format %0.${repr}f $n] ;# Take out of scientific notation
            set map [string map {. {}} $long] ;# Remove decimal point
            set trim [string trimleft $map 0] ;# Remove leading zeros
            # restore string for comparison
            set len [string length $trim]
            if {$len < $prec} {
                set trim "${trim}[string repeat 0 [expr ($prec+1)-$len]]"
            }
            # Round last decimal place
            set rounded [format %0.f "[string range $trim 0 [expr {$prec-1}]].[string index $trim $prec]"]
            return $rounded
        }
        set a_coeff [toCoeff $a $prec]
        set b_coeff [toCoeff $b $prec]

        return [expr {$a_coeff == $b_coeff}]
    }

    set data {
        {100000000000000.01 100000000000000.011}
        {100.01 100.011}
        {[expr {10000000000000.001 / 10000.0}] 1000000000.0000001000}
        {0.001 0.0010000001}
        {0.000000000000000000000101 0.0}
        {[expr { sqrt(2) * sqrt(2)}] 2.0}
        {[expr {-sqrt(2) * sqrt(2)}] -2.0}
        {3.14159265358979323846 3.14159265358979324}
    }
    set data [subst $data] ;# resolves expressions in the list

    foreach {a b} [join $data] {
        puts [format "Is %26s ≈ %21s ? %4s." $a $b $yesno([isClose $a $b])]
    }
}
