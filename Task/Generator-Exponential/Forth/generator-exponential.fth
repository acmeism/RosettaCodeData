\ genexp-rcode.fs   Generator/Exponential for RosettaCode.org

\ Generator/filter implementation using return stack as continuations stack
: ENTER         ( cont.addr --  ;borrowed from M.L.Gasanenko papers)
        >R
;
: |             ( f --  ;true->go ahead, false->return into generator )
        IF EXIT THEN R> DROP
;
: GEN           ( --  ;generate forever what is between 'GEN' and ';' )
        BEGIN R@ ENTER AGAIN
;
: STOP          ( f --  ;return to caller of word that contain 'GEN' )
        IF R> DROP R> DROP R> DROP THEN
;

\ Problem at hand
: square        ( n -- n^2 )    dup * ;
: cube          ( n -- n^3 )    dup square * ;

\ Faster tests using info that tested numbers are monotonic growing
        VARIABLE Sqroot         \ last square root
        VARIABLE Cbroot         \ last cubic  root
: square?       ( u -- f  ;test U for square number)
        BEGIN
                Sqroot @ square over <
        WHILE
                1 Sqroot +!
        REPEAT
        Sqroot @ square =
;
: cube?         ( u -- f  ;test U for cubic  number)
        BEGIN
                Cbroot @ cube over <
        WHILE
                1 Cbroot +!
        REPEAT
        Cbroot @ cube =
;
        VARIABLE Counter
: (go)  ( u -- u' )
        GEN 1+ Counter @ 30 >= STOP
        dup square? | dup cube? 0= | Counter @ 20 >= 1 Counter +! | dup .
;
:noname 0 Counter ! 1 Sqroot ! 1 Cbroot ! 0 (go) drop ;
execute cr bye
