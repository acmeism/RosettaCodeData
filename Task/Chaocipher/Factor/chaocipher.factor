USING: arrays combinators fry io kernel locals math namespaces
prettyprint sequences sequences.extras strings ;
IN: rosetta-code.chaocipher

CONSTANT: zenith 0
CONSTANT: nadir  13

SYMBOLS: l-alphabet r-alphabet last-index ;

: init-alphabets ( -- )
    "HXUCZVAMDSLKPEFJRIGTWOBNYQ" l-alphabet
    "PTLNBQDEOYSFAVZKGJRIHWXUMC" r-alphabet [ set ] 2bi@ ;

: zero-alphabet ( seq -- seq' )
    last-index get rotate ;

: 3append ( a b c d -- abcd )
    append append append ;

:: permute-l-alphabet ( -- )
    l-alphabet get zero-alphabet dup
    zenith 1 + swap nth :> extracted-char
    {
        [ 1 head ]
        [ nadir 1 + head 2 tail ]
        [ drop extracted-char 1string ]
        [ nadir 1 + tail ]
    } cleave
    3append l-alphabet set ;

:: permute-r-alphabet ( -- )
    r-alphabet get zero-alphabet
    1 rotate dup
    zenith 2 + swap nth :> extracted-char
    {
        [ 2 head ]
        [ nadir 1 + head 3 tail ]
        [ drop extracted-char 1string ]
        [ nadir 1 + tail ]
    } cleave
    3append r-alphabet set ;

: encipher-char ( char alpha1 alpha2 -- char' )
    '[ _ get index dup last-index set _ get nth ] call ;

: encipher ( str quot -- str' )
    [ permute-l-alphabet permute-r-alphabet ] compose map
    init-alphabets ; inline

: encrypt ( str -- str' )
    [ r-alphabet l-alphabet encipher-char ] encipher ;

: decrypt ( str -- str' )
    [ l-alphabet r-alphabet encipher-char ] encipher ;

: main ( -- )
    init-alphabets
    "WELLDONEISBETTERTHANWELLSAID" encrypt dup decrypt
    [ print ] bi@ ;

MAIN: main
