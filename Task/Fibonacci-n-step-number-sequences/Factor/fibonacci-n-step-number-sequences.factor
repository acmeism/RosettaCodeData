USING: formatting fry kernel make math namespaces qw sequences ;

: n-bonacci ( n initial -- seq ) [
        [ [ , ] each ] [ length - ] [ length ] tri
        '[ building get _ tail* sum , ] times
    ] { } make ;

qw{ fibonacci tribonacci tetranacci lucas }
{ { 1 1 } { 1 1 2 } { 1 1 2 4 } { 2 1 } }
[ 10 swap n-bonacci "%-10s %[%3d, %]\n" printf ] 2each
