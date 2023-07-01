: 3drop   drop 2drop ;
: f2drop  fdrop fdrop ;

: int-array  create cells allot  does> swap cells + ;

: 1st-fib   0e 1e ;
: next-fib  ftuck f+ ;

: 1st-digit ( fp -- n )
    pad 6 represent 3drop pad c@ [char] 0 - ;

10 int-array counts

: tally
    0 counts 10 cells erase
    1st-fib
    1000 0 DO
        1 fdup 1st-digit counts +!
        next-fib
    LOOP f2drop ;

: benford ( d -- fp )
    s>f 1/f 1e f+ flog ;

: tab  9 emit ;

: heading  ( -- )
    cr ." Leading digital distribution of the first 1,000 Fibonacci numbers:"
    cr ." Digit" tab ." Actual" tab ." Expected" ;

: .fixed ( n -- ) \ print count as decimal fraction
    s>d <# # # # [char] . hold #s #> type space ;

: report ( -- )
    precision  3 set-precision
    heading
    10 1 DO
        cr i 3 .r
        tab i counts @ .fixed
        tab i benford f.
    LOOP
    set-precision ;

: compute-benford  tally report ;
