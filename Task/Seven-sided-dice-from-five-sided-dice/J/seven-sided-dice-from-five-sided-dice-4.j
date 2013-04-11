getNumRolls=: [: >. 0.75 * */@[       NB. calc approx 3/4 of the required rolls
accumD7Rolls=: ] , getD7@getNumRolls  NB. accumulates getD7 rolls
isNotEnough=: */@[ > #@]              NB. checks if enough D7 rolls accumulated

rollD7t=: ] $ (accumD7Rolls ^: isNotEnough ^:_)&''
