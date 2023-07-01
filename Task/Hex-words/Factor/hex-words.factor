USING: formatting io io.encodings.ascii io.files kernel literals
math math.parser prettyprint sequences sets sorting ;

CONSTANT: words $[
    "unixdict.txt" ascii file-lines
    [ length 3 > ] filter
    [ "abcdef" subset? ] filter
]

: droot ( m -- n ) 1 - 9 mod 1 + ;

: info. ( str -- ) dup hex> dup droot "%-8s-> %-10d-> %d\n" printf ;

: info-by ( quot ? -- )
    [ sort-with ] [ inv-sort-with ] if [ length ] keep
    [ info. ] each pprint ; inline

words [ hex> droot ] t info-by
" hex words with 4 or more letters found." print nl

words [ cardinality 3 > ] filter [ hex> ] f info-by
" such words found which contain 4 or more different digits." print
