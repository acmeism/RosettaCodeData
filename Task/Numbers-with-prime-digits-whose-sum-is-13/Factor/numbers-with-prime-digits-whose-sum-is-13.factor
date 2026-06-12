USING: formatting io kernel math math.combinatorics
math.functions math.ranges sequences sequences.extras ;

: digits>number ( seq -- n ) reverse 0 [ 10^ * + ] reduce-index ;

"Numbers whose digits are prime and sum to 13:" print
{ 2 3 5 7 } 3 6 [a,b] [ selections [ sum 13 = ] filter ] with
map-concat [ digits>number ] map "%[%d, %]\n" printf
