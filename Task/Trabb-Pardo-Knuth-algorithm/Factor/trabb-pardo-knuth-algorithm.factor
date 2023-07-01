USING: formatting io kernel math math.functions math.parser
prettyprint sequences splitting ;
IN: rosetta-code.trabb-pardo-knuth

CONSTANT: threshold 400
CONSTANT: prompt "Please enter 11 numbers: "

: fn ( x -- y ) [ abs 0.5 ^ ] [ 3 ^ 5 * ] bi + ;

: overflow? ( x -- ? ) threshold > ;

: get-input ( -- seq )
    prompt write flush readln " " split dup length 11 =
    [ drop get-input ] unless ;

: ?result ( ..a quot: ( ..a -- ..b ) -- ..b )
    [ "f(%u) = " sprintf ] swap bi dup overflow?
    [ drop "overflow" ] [ "%.3f" sprintf ] if append ; inline

: main ( -- )
    get-input reverse
    [ string>number [ fn ] ?result print ] each ;

MAIN: main
