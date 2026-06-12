USING: formatting kernel locals math math.functions math.ranges
sequences ;
IN: rosetta-code.simpsons

:: simps ( f a b n -- x )
    n even?
    [ n "n must be even; %d was given" sprintf throw ] unless
    b a - n / :> h
    1 n 2 <range> 2 n 1 - 2 <range>
    [ [ a + h * f call ] map-sum ] bi@ [ 4 ] [ 2 ] bi*
    [ * ] 2bi@ a b [ f call ] bi@ + + + h 3 / * ; inline

[ sin ] 0 1 100 simps
"Simpson's rule integration of sin from 0 to 1 is: %u\n" printf
