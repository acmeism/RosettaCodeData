   # find5wkdMonths 1900 2100                        NB. number of months found
201
   (5&{. , '...' , _5&{.) find5wkdMonths 1900 2100   NB. First and last 5 months found
Mar 1901
Aug 1902
May 1903
Jan 1904
Jul 1904
...
Mar 2097
Aug 2098
May 2099
Jan 2100
Oct 2100
   # (range -. {:"1@(_ ". find5wkdMonths)) 1900 2100   NB. number of years without 5 weekend months
29
