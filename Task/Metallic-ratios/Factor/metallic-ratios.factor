USING: combinators decimals formatting generalizations io kernel
math prettyprint qw sequences ;
IN: rosetta-code.metallic-ratios

: lucas ( n a b -- n a' b' ) tuck reach * + ;

: lucas. ( n -- )
    1 pprint bl 1 1 14 [ lucas over pprint bl ] times 3drop nl ;

: approx ( a b -- d ) swap [ 0 <decimal> ] bi@ 32 D/ ;

: approximate ( n -- value iter )
    -1 swap 1 1 0 1 [ 2dup = ]
    [ [ 1 + ] 5 ndip [ lucas 2dup approx ] 2dip drop ] until
    4nip decimal>ratio swap ;

qw{
    Platinum Golden Silver Bronze Copper Nickel Aluminum Iron
    Tin Lead
}
[
    dup dup approximate {
        [ "Lucas sequence for %s ratio " printf ]
        [ "where b = %d:\n" printf ]
        [ "First 15 elements: " write lucas. ]
        [ "Approximated value: %.32f " printf ]
        [ "- reached after  %d  iteration(s)\n\n" printf ]
    } spread
] each-index
