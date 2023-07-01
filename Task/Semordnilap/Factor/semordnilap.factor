USING: assocs combinators.short-circuit formatting
io.encodings.utf8 io.files kernel literals locals make
prettyprint random sequences ;
IN: rosetta-code.semordnilap

CONSTANT: words $[ "unixdict.txt" utf8 file-lines ]

: semordnilap? ( str1 str2 -- ? )
    { [ = not ] [ nip words member? ] } 2&& ;

[
    [let
        V{ } clone :> seen words
        [
            dup reverse 2dup
            { [ semordnilap? ] [ drop seen member? not ] } 2&&
            [ 2dup [ seen push ] bi@ ,, ] [ 2drop ] if
        ] each
    ]
] H{ } make >alist
[ length "%d semordnilap pairs.\n" printf ] [ 5 sample . ] bi
