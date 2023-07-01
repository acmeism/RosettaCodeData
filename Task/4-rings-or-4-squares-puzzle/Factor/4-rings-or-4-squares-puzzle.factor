USING: arrays backtrack formatting grouping kernel locals math
math.ranges prettyprint sequences sequences.generalizations
sets ;
IN: rosetta-code.4-rings

:: 4-rings ( lo hi unique? -- seq ) [
        7 [ lo hi [a,b] amb-lazy ] replicate
        7 firstn :> ( a b c d e f g )
        { a b c d e f g } :> p
        a b +
        b c d + +
        d e f + +
        f g +
        4array all-equal?
        unique? [ p all-unique? and ] when
        must-be-true p
    ] bag-of ;

: report ( lo hi unique? -- )
    3dup 4-rings over [ dup . ] when length swap "" "non-" ?
    "In [%d, %d] there are %d %sunique solutions.\n" printf ;

1 7 t report
3 9 t report
0 9 f report
