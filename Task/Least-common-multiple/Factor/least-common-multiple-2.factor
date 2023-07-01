USING: kernel math prettyprint ;
IN: script

: gcd ( a b -- c )
    [ abs ] [
        [ nip ] [ mod ] 2bi gcd
    ] if-zero ;

: lcm ( a b -- c )
    [ * abs ] [ gcd ] 2bi / ;

26 28 lcm .
