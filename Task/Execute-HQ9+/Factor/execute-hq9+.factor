USING: combinators command-line formatting interpolate io kernel
math math.ranges multiline namespaces sequences ;
IN: rosetta-code.hq9+

STRING: verse
${3} bottle${1} of beer on the wall
${3} bottle${1} of beer
Take one down, pass it around
${2} bottle${0} of beer on the wall
;

: bottles ( -- )
    99 1 [a,b]
    [ dup 1 - 2dup [ 1 = "" "s" ? ] bi@ verse interpolate nl ]
    each ;

SYMBOL: accumulator

CONSTANT: commands
{
    { CHAR: H [ drop "Hello, world!" print ] }
    { CHAR: Q [ print ] }
    { CHAR: 9 [ drop bottles ] }
    { CHAR: + [ drop accumulator inc ] }
    [ nip "Invalid command: %c" sprintf throw ]
}

: interpret-HQ9+ ( str -- )
    dup [ commands case ] with each accumulator off ;

: main ( -- ) command-line get first interpret-HQ9+ ;

MAIN: main
