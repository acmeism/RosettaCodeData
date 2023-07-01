USING: accessors kernel lists literals namespaces
parser-combinators prettyprint sequences strings ;

SYMBOLS: esc sep ;

: set-chars ( m n -- ) [ sep set ] [ esc set ] bi* ;
: escape ( -- parser ) esc get 1token ;
: escaped ( -- parser ) escape any-char-parser &> ;
: separator ( -- parser ) sep get 1token ;

: character ( -- parser )
    ${ esc get sep get } [ member? not ] curry satisfy ;

: my-token ( -- parser ) escaped character <|> <*> ;

: token-list ( -- parser )
    my-token separator list-of [ [ >string ] map ] <@ ;

: tokenize ( str sep-char esc-char -- seq )
    set-chars token-list parse car parsed>> ;

"one^|uno||three^^^^|four^^^|^cuatro|"
CHAR: | CHAR: ^ tokenize .
