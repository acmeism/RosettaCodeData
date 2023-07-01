USING: fry kernel math ;
IN: rosettacode.Y
: Y ( quot -- quot )
    '[ [ dup call call ] curry @ ] dup call ; inline

: almost-fac ( quot -- quot )
    '[ dup zero? [ drop 1 ] [ dup 1 - @ * ] if ] ;

: almost-fib ( quot -- quot )
    '[ dup 2 >= [ 1 2 [ - @ ] bi-curry@ bi + ] when ] ;
