USING: combinators.extras formatting kernel math.functions
math.matrices math.vectors prettyprint sequences ;

: show ( a b words -- )
    [
        3dup execute( x x -- x ) [ unparse ] dip
        "%u %u %s = %u\n" printf
    ] 2with each ; inline

: m^n ( m n -- m ) [ ^ ] curry matrix-map ;
: m^  ( m m -- m ) [ v^ ] 2map ;

{ { 1 2 } { 3 4 } } { { 5 6 } { 7 8 } } { m+ m- m* m/ m^ }
{ { -1 9 4 } { 5 -13 0 } } 3 { m+n m-n m*n m/n m^n }
[ show ] 3bi@
