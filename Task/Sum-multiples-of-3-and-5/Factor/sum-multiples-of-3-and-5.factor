USING: formatting kernel math math.functions sequences
tools.time ;
IN: rosetta-code.sum35

: {x+y-z} ( {x,y,z} -- x+y-z ) first3 [ + ] dip - ;

: range-length ( limit multiple -- len ) [ 1 - ] dip /i ;

: triangular ( limit multiple -- sum )
    [ range-length ] [ nip over 1 + ] 2bi * * 2 / ;

: sum35 ( limit -- sum )
    { 3 5 15 } [ triangular ] with map {x+y-z} ;

: msg ( limit sum -- )
    "The sum of multiples of 3 or 5 below %d is %d.\n" printf ;

: output ( limit -- ) dup sum35 msg ;

: main ( -- ) [ 1000 10 20 ^ [ output ] bi@ ] time ;

MAIN: main
