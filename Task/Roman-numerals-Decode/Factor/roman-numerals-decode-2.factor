CONSTANT: roman-digits
    { "m" "cm" "d" "cd" "c" "xc" "l" "xl" "x" "ix" "v" "iv" "i" }

CONSTANT: roman-values
    { 1000 900 500 400 100 90 50 40 10 9 5 4 1 }

: roman> ( str -- n )
  >lower [ roman-digit>= ] monotonic-split
  [ roman-value ] map-sum ;

: roman-digit>= ( ch1 ch2 -- ? ) [ roman-digit-index ] bi@ >= ;

: roman-digit-index ( ch -- n ) 1string roman-digits index ;

: roman-value (seq -- n )
  [ [ roman-digit-value ] map ] [ all-eq? ] bi
  [ sum ] [ first2 swap - ] if ;

: roman-digit-value ( ch -- n )
  roman-digit-index roman-values nth ;
