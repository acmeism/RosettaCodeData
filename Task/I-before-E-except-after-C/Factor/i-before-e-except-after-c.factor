USING: combinators formatting generalizations io.encodings.utf8
io.files kernel literals math prettyprint regexp sequences ;
IN: rosetta-code.i-before-e

: correct ( #correct #incorrect rule-str -- )
    pprint " is correct for %d and incorrect for %d.\n" printf ;

: plausibility ( #correct #incorrect -- str )
    2 * > "plausible" "implausible" ? ;

: output ( #correct #incorrect rule-str -- )
    [ correct ] curry
    [ plausibility "This is %s.\n\n" printf ] 2bi ;

"unixdict.txt" utf8 file-lines ${
    R/ cei/ R/ cie/ R/ [^c]ie/ R/ [^c]ei/
    [ count-matches ]
    [ map-sum       ]
    [ 4 apply-curry ] bi@
} cleave

"I before E when not preceded by C"
"E before I when preceded by C" [ output ] bi@
