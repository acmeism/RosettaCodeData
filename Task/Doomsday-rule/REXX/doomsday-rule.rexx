/*REXX program finds the day─of─week for a specified date using Conway's Doomsday rule. */
parse arg $                                      /*obtain optional arguments from the CL*/
if $='' | $=","  then $=  ,                      /*Not specified?  Then use the default.*/
            '01/06/1800 03/29/1875 12/07/1915 12/23/1970 05/14/2043 04/02/2077 04/02/2101'
d= 'Sun Mon Tues Wednes Thurs Fri Satur'         /*list of days of the week, sans "day".*/
y.0= 3 7 7 4 2 6 4 1 5 3 7 5                     /*doomsday dates for non-leapyear month*/
y.1= 4 1 7 4 2 6 4 1 5 3 7 5                     /*    "      "    "      leapyear   "  */

      do j=1  for words($);        datum= word($, j)    /*process each of the dates.    */
      parse var  datum    mm  '/'  dd  "/"  yy          /*parse the date  ──►  mm dd yy */
      ly= leapyear(yy)                                  /*get indication of a leapyear. */
      wd= (doomsday(yy)+dd-word(y.ly, mm) + 7) // 7 + 1 /*obtain a code for the weekday.*/
      say datum    ' falls on '    word(d, wd)"day"     /*display day-of-week for date. */
      end   /*j*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
doomsday: parse arg ?;  return (2  +  5 * (?//4)  +  4 * (?//100)  +  6 * (?//400) ) // 7
leapyear: arg #; ly= #//4==0; if ly==0  then return 0;   return ((#//100\==0) | #//400==0)
