USING: formatting io kernel math math.functions sequences ;
IN: rosetta-code.test-integerness

GENERIC: integral? ( n -- ? )

M: real integral? [ ] [ >integer ] bi number= ;
M: complex integral? >rect [ integral? ] [ 0 number= ] bi* and ;

GENERIC# fuzzy-int? 1 ( n tolerance -- ? )

M: real fuzzy-int? [ dup round - abs ] dip <= ;
M: complex fuzzy-int? [ >rect ] dip swapd fuzzy-int? swap 0
    number= and ;

{
    25/1
    50+2/3
    34/73
    312459210312903/129381293812491284512951
    25.000000
    24.999999
    25.000100
    -2.1e120
    -5e-2
    0/0. ! NaN
    1/0. ! Infinity
    C{ 5.0 0.0 }
    C{ 5 -5 }
    C{ 5 0 }
}
"Number" "Exact int?" "Fuzzy int? (tolerance=0.00001)"
"%-41s %-11s %s\n" printf
[
   [ ] [ integral? ] [ 0.00001 fuzzy-int? ] tri
   "%-41u %-11u %u\n" printf
] each
