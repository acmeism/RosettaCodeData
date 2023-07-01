   require 'tables/dsv dates'
   dat=: TAB readdsv jpath '~temp/readings.txt'
   Dates=: getdate"1 >{."1 dat
   Vals=:  _99 ". >(1 + +: i.24){"1 dat
   Flags=: _99 ". >(2 + +: i.24){"1 dat

   # Dates                      NB. Total # lines
5471
   +/ *./"1 ] 0 = Dates         NB. # lines with invalid date formats
0
   +/ _99 e."1 Vals,.Flags      NB. # lines with invalid value or flag formats
0
   +/ *./"1   [0 < Flags        NB. # lines with only valid flags
5017
   ~. (#~ (i.~ ~: i:~)) Dates   NB. Duplicate dates
1990 3 25
1991 3 31
1992 3 29
1993 3 28
1995 3 26
