USING: formatting fry io kernel math math.ranges math.statistics
random sequences ;
IN: rosetta-code.mean-run-density

: rising? ( ? ? -- ? ) [ f = ] [ t = ] bi* and ;

: count-run ( n ? ? -- m ? )
    2dup rising? [ [ 1 + ] 2dip ] when nip ;

: runs ( n p -- n )
    [ 0 f ] 2dip '[ random-unit _ < count-run ] times drop ;

: rn ( n p -- x ) over [ runs ] dip /f ;

: sim ( n p -- avg )
    [ 1000 ] 2dip [ rn ] 2curry replicate mean ;

: theory ( p -- x ) 1 over - * ;

: result ( n p -- )
    [ swap ] [ sim ] [ nip theory ] 2tri 2dup - abs
    "%.1f  %-5d  %.4f  %.4f  %.4f\n" printf ;

: test ( p -- )
    { 100 1,000 10,000 } [ swap result ] with each nl ;

: header ( -- )
    "1000 tests each:\np    n      K       p(1-p)  diff" print ;

: main ( -- ) header .1 .9 .2 <range> [ test ] each ;

MAIN: main
