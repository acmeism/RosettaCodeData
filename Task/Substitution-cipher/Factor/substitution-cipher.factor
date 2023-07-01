USING: assocs combinators combinators.short-circuit command-line
hashtables io io.encodings.utf8 io.files kernel math.order
multiline namespaces qw sequences ;
IN: rosetta-code.substitution-cipher

CONSTANT: alphabet
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

CONSTANT: default-key
    "VsciBjedgrzyHalvXZKtUPumGfIwJxqOCFRApnDhQWobLkESYMTN"

SYMBOL: key

STRING: usage
Usage:
  substitution
  <encode|decode>
  input-file
  output-file
  [key-file]  (Optional -- for custom alphabet keys.)

Example:
  substitution encode my-poem.txt my-encoded-poem.txt
;

: check-args ( seq -- ? )
    {
        [ length 3 4 between? not ]
        [ first qw{ encode decode } member? not ]
    } 1|| [ usage print f ] [ t ] if ;

: init-key ( seq -- )
    dup length 4 = [ last utf8 file-contents ]
    [ drop default-key ] if key set ;

: >sub-map ( seq -- assoc )
    [ alphabet key get ] dip first "encode" = [ swap ] unless
    zip >hashtable ;

: encipher ( seq assoc -- newseq )
    [ dupd at dup [ nip ] [ drop ] if ] curry { } map-as ;

: substitute ( seq -- )
    { [ init-key ] [ second ] [ >sub-map ] [ third ] } cleave
    [ utf8 file-contents ] [ encipher ]
    [ utf8 set-file-contents ] tri* ;

: main ( -- )
    command-line get dup check-args [ substitute ] [ drop ] if ;

MAIN: main
