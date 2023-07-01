\ if department numbers are valid, print them on a single line
: fire ( pol san fir -- )
    2dup = if 2drop drop exit then
    2 pick over = if 2drop drop exit then
    rot . swap . . cr ;

\ tries to assign numbers with given policeno and sanitationno
\ and fire = 12 - policeno - sanitationno
: sanitation ( pol san -- )
    2dup = if 2drop exit then             \ no repeated numbers
    12 over - 2 pick -                    \ calculate fireno
    dup 1 < if 2drop drop exit then       \ cannot be less than 1
    dup 7 > if 2drop drop exit then       \ cannot be more than 7
    fire ;

\ tries to assign numbers with given policeno
\ and sanitation = 1, 2, 3, ..., or 7
: police ( pol -- )
    8 1 do dup i sanitation loop drop ;

\ tries to assign numbers with police = 2, 4, or 6
: departments cr                          \ leave input line
    8 2 do i police 2 +loop ;
