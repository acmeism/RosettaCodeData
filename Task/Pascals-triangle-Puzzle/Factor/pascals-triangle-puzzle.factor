USING: arrays backtrack combinators.extras fry grouping.extras
interpolate io kernel math math.ranges sequences ;
IN: rosetta-code.pascals-triangle-puzzle

: base ( ?x ?z -- seq ) 2dup + swap '[ _ 11 _ 4 _ ] >array ;

: up ( seq -- seq' ) [ [ + ] 2clump-map ] twice ;

: find-solution ( -- x z )
    10 [1,b] dup [ amb-lazy ] bi@ 2dup base
    up dup first 40 = must-be-true
    up first 151 = must-be-true ;

find-solution [I X = ${1}, Z = ${}I] nl
