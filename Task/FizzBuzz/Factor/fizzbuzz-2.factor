USING: kernel sequences arrays generalizations fry math math.parser prettyprint ;
IN: fizzbuzz

: zz ( m seq -- v ) dup length 1 <array> V{ } clone 4 -nrot 1 4 -nrot 3 nrot
 '[ dup _ <= ]
  3 -nrot
 '[
    "" _ [ _ [ swap execute( str n -- str n ) ] change-nth ] each-index
    dup empty? [ drop dup number>string ] [ ] if swapd suffix! swap 1 +
  ]
  while drop ;

: fizz ( str n -- str n ) dup 3 < [ 1 + ] [ drop "Fizz" append 1 ] if ;
: buzz ( str n -- str n ) dup 5 < [ 1 + ] [ drop "Buzz" append 1 ] if ;
: quxx ( str n -- str n ) dup 7 < [ 1 + ] [ drop "Quxx" append 1 ] if ;
: FizzBuzzQuxx ( m -- v ) { fizz buzz quxx } zz ;
: FizzBuzzQuxx-100 ( -- ) 100 FizzBuzzQuxx . ;

MAIN: FizzBuzzQuxx-100
