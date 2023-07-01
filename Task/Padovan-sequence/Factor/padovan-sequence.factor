USING: L-system accessors io kernel make math math.functions
memoize prettyprint qw sequences ;

CONSTANT: p 1.324717957244746025960908854
CONSTANT: s 1.0453567932525329623

: pfloor ( m -- n ) 1 - p swap ^ s /f .5 + >integer ;

MEMO: precur ( m -- n )
    dup 3 < [ drop 1 ]
    [ [ 2 - precur ] [ 3 - precur ] bi + ] if ;

: plsys, ( L-system -- )
    [ iterate-L-system-string ] [ string>> , ] bi ;

: plsys ( n -- seq )
    <L-system>
    "A" >>axiom
    { qw{ A B } qw{ B C } qw{ C AB } } >>rules
    swap 1 - '[ "A" , _ [ dup plsys, ] times ] { } make nip ;

"First 20 terms of the Padovan sequence:" print
20 [ pfloor pprint bl ] each-integer nl nl

64 [ [ pfloor ] [ precur ] bi assert= ] each-integer
"Recurrence and floor based algorithms match to n=63." print nl

"First 10 L-system strings:" print
10 plsys . nl

32 <iota> [ pfloor ] map 32 plsys [ length ] map assert=
"The L-system, recurrence and floor based algorithms match to n=31." print
