USING: kernel math prettyprint ;

: sum-multiples ( m n upto -- sum )
    >integer 1 - [ 2dup * ] dip
    [ 2dup swap [ mod - + ] [ /i * 2/ ] 2bi ] curry tri@
    [ + ] [ - ] bi* ;

3 5 1000 sum-multiples .
3 5 1e20 sum-multiples .
