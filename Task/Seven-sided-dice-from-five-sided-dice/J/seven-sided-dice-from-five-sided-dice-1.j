rollD5=: [: >: ] ?@$ 5:      NB. makes a y shape array of 5s, "rolls" the array and increments.
roll2xD5=: [: rollD5 2 ,~ */ NB. rolls D5 twice for each desired D7 roll (y rows, 2 cols)
toBase10=: 5 #. <:           NB. decrements and converts rows from base 5 to 10
keepGood=: #~ 21&>           NB. compress out values not less than 21
groupin3s=: [: >. >: % 3:    NB. increments, divides by 3 and takes ceiling

getD7=: groupin3s@keepGood@toBase10@roll2xD5
