\ Brute force search, optimized to search only within integer bounds surrounding target
\ Forth 200x compliant

: RealToRational  ( float_target int_denominator_limit -- numerator denominator )
    {:  f: thereal denlimit | realscale  numtor denom neg? f: besterror f: temperror :}
    0 to numtor
    0 to denom
    9999999e to besterror                 \ very large error that will surely be improved upon
    thereal F0< to neg?                   \ save sign for later
    thereal FABS to thereal

    thereal FTRUNC f>s 1+ to realscale      \ realscale helps set integer bounds around target

    denlimit 1+ 1 ?DO                    \ search through possible denominators ( 1 to denlimit)

        I realscale *  I realscale 1- *  ?DO    \ search within integer limits bounding the real
            I s>f  J s>f  F/                    \ e.g. for 3.1419e search only between 3 and 4
            thereal F- FABS to temperror

            temperror besterror F< IF
                temperror to besterror I to numtor J to denom
            THEN
        LOOP

    LOOP

    neg? IF numtor NEGATE to numtor THEN

    numtor denom
;
(run)
1.618033988e 100 RealToRational  swap . . 144 89
3.14159e 1000 RealToRational swap . . 355 113
2.71828e 1000 RealToRational swap . . 1264 465
0.9054054e 100 RealToRational swap . . 67  74
