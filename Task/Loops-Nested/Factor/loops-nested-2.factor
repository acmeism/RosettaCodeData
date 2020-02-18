USING: continuations io kernel math.ranges prettyprint random
sequences ;

10 [ 20 [ 20 [1,b] random ] replicate ] replicate             ! make a table of random values
[
    [ [ dup pprint bl 20 = [ return ] when ] each nl ] each   ! print values until 20 is found
] with-return drop
