catch {namespace delete test_almost_equal_decimal} ;# Start with a clean namespace

namespace eval test_almost_equal_decimal {
    package require Tcl 8.5 ;# required by tcllib
    package require math::decimal ;# from tcllib
    namespace import ::math::decimal::* ;# for: setVariable, fromstr, and compare

    array set yesno {0 Yes -1 No 1 No} ;# For nice output

    # More info here: http://speleotrove.com/decimal/dax3274.html
    # This puts the library into "simplified" mode. Which
    # rounds the "decimal digits" in the coefficient to the
    # number of digits that "precision" is set to.
    setVariable extended 0
    setVariable precision 9

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
        set a_d [fromstr $a]
        set b_d [fromstr $b]

        puts [format "Is %26s ≈ %21s ? %4s." $a $b $yesno([compare $a_d $b_d])]
    }
}
