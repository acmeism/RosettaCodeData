USING: accessors combinators formatting inverse kernel math
math.constants quotations qw sequences units.si ;
IN: rosetta-code.angles

ALIAS: degrees arc-deg
: gradiens ( n -- d ) 9/10 * degrees ;
: mils ( n -- d ) 9/160 * degrees ;
: normalize ( d -- d' ) [ 2 pi * mod ] change-value ;
CONSTANT: units { degrees gradiens mils radians }

: .row ( angle unit -- )
    2dup "%-12u%-12s" printf ( x -- x ) execute-effect
    normalize units [ 1quotation [undo] call( x -- x ) ] with
    map "%-12.4f%-12.4f%-12.4f%-12.4f\n" vprintf ;

: .header ( -- )
    qw{ angle unit } units append
    "%-12s%-12s%-12s%-12s%-12s%-12s\n" vprintf ;

: angles ( -- )
    .header
    { -2 -1 0 1 2 6.2831853 16 57.2957795 359 399 6399 1000000 }
    units [ .row ] cartesian-each ;

MAIN: angles
