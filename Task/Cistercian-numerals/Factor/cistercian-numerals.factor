USING: combinators continuations formatting grouping io kernel
literals math.order math.text.utils multiline sequences
splitting ;

CONSTANT: numerals $[
HEREDOC: END
  +    +-+  +    +    + +  +-+  + +  +-+  + +  +-+
  |    |    |    |\   |/   |/   | |  | |  | |  | |
  |    |    +-+  | +  +    +    | +  | +  +-+  +-+
  |    |    |    |    |    |    |    |    |    |
  |    |    |    |    |    |    |    |    |    |
  |    |    |    |    |    |    |    |    |    |
  +    +    +    +    +    +    +    +    +    +
END
"\n" split harvest [ 5 group ] map flip
]

: precedence ( char char -- char )
    2dup [ CHAR: + = ] either? [ 2drop CHAR: + ] [ max ] if ;

: overwrite ( glyph glyph -- newglyph )
    [ [ precedence ] 2map ] 2map ;

: flip-slashes ( str -- new-str )
    [
        {
            { CHAR: / [ CHAR: \ ] }
            { CHAR: \ [ CHAR: / ] }
            [ ]
        } case
    ] map ;

: hflip ( seq -- newseq ) [ reverse flip-slashes ] map ;
: vflip ( seq -- newseq ) reverse [ flip-slashes ] map ;

: get-digits ( n -- seq ) 1 digit-groups 4 0 pad-tail ;

: check-cistercian ( n -- )
    0 9999 between? [ "Must be from 0 to 9999." throw ] unless ;

: .cistercian ( n -- )
    [ check-cistercian ] [ "%d:\n" printf ] [ get-digits ] tri
    [ numerals nth ] map
    [ { [ ] [ hflip ] [ vflip ] [ hflip vflip ] } spread ]
    with-datastack [ ] [ overwrite ] map-reduce [ print ] each ;

{ 0 1 20 300 4000 5555 6789 8015 } [ .cistercian nl ] each
