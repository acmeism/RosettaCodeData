USING: io kernel lists lists.lazy math math.functions
math.text.utils prettyprint sequences ;
IN: rosetta-code.narcissistic-decimal-number

: digit-count ( n -- count ) log10 floor >integer 1 + ;

: narcissist? ( n -- ? ) dup [ 1 digit-groups ]
    [ digit-count [ ^ ] curry ] bi map-sum = ;

: first25 ( -- seq ) 25 0 lfrom [ narcissist? ] lfilter
    ltake list>array ;

: main ( -- ) first25 [ pprint bl ] each ;

MAIN: main
