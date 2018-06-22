USING: formatting io kernel math math.ranges prettyprint
sequences ;
IN: rosetta-code.multifactorial

: multifactorial ( n degree -- m )
    neg 1 swap <range> product ;

: mf-row ( degree -- )
    dup "Degree %d: " printf
    10 [1,b] [ swap multifactorial pprint bl ] with each ;

: main ( -- )
    5 [1,b] [ mf-row nl ] each ;

MAIN: main
