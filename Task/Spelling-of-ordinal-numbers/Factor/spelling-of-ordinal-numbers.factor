USING: assocs formatting grouping kernel literals locals math
math.parser math.text.english qw regexp sequences
splitting.extras ;
IN: rosetta-code.spelling-ordinal-numbers

<PRIVATE

! Factor supports the arbitrary use of commas in integer
! literals, as some number systems (e.g. Indian) don't solely
! break numbers up into triplets.

CONSTANT: test-cases qw{
    1 2 3 4 5 11 65 100 101 272 23456 8007006005004003 123
    00123.0 1.23e2 1,2,3 0b1111011 0o173 0x7B 2706/22
}

CONSTANT: replacements $[
    qw{
        one    first
        two    second
        three  third
        five   fifth
        eight  eighth
        nine   ninth
        twelve twelfth
    } 2 group
]

: regular-ordinal ( n -- str )
    [ number>text ] [ ordinal-suffix ] bi append ;

! Since Factor's number>text word contains commas and "and",
! strip them out with a regular expression.

: text>ordinal-text ( str -- str' ) R/ \sand|,/ "" re-replace ;

PRIVATE>

:: number>ordinal-text ( n! -- str )
    n >integer n!
    n number>text " ,-" split* dup last replacements at
    [ [ but-last ] dip suffix "" join ]
    [ drop n regular-ordinal          ] if* text>ordinal-text ;

<PRIVATE

: print-ordinal-pair ( str x -- )
    number>ordinal-text "%16s => %s\n" printf ;

PRIVATE>

: ordinal-text-demo ( -- )
    test-cases [ dup string>number print-ordinal-pair ] each
    "C{ 123 0 }" C{ 123 0 } print-ordinal-pair ;

MAIN: ordinal-text-demo
