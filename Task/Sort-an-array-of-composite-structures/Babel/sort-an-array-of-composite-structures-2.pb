babel> 20 lsrange ! {1 randlf 2 rem} lssort ! 2 group ! --> this creates a shuffled list of pairs
babel> dup {lsnum !} ... --> display the shuffled list, pair-by-pair
( 11 10 )
( 15 13 )
( 12 16 )
( 17 3 )
( 14 5 )
( 4 19 )
( 18 9 )
( 1 7 )
( 8 6 )
( 0 2 )
babel> {<- car -> car lt? } lssort ! --> sort the list by first element of each pair
babel> dup {lsnum !} ... --> display the sorted list, pair-by-pair
( 0 2 )
( 1 7 )
( 4 19 )
( 8 6 )
( 11 10 )
( 12 16 )
( 14 5 )
( 15 13 )
( 17 3 )
( 18 9 )
