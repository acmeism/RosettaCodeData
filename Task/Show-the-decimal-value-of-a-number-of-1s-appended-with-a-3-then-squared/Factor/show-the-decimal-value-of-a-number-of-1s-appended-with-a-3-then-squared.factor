USING: io kernel math math.functions prettyprint ;

: a ( n -- e m ) 1 + 10^ 1 - 9 / 2 + dup sq ;

8 [ a swap pprint bl . ] each-integer
