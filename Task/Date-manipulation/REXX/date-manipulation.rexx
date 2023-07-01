/*REXX program adds 12 hours to a  given date and time, displaying the before and after.*/
 aDate = 'March 7 2009 7:30pm EST'               /*the original or base date to be used.*/

parse var aDate mon dd yyyy hhmm tz .            /*obtain the various parts and pieces. */

  mins = time('M', hhmm, "C")                    /*get the number minutes past midnight.*/
  mins = mins + (12*60)                          /*add  twelve hours  to the  timestamp.*/
 nMins = mins // 1440                            /*compute number min into same/next day*/
  days = mins %  1440                            /*compute number of days added to dats.*/
aBdays = date('B', dd left(mon,3) yyyy)          /*number of base days since REXX epoch.*/
nBdays = aBdays + days                           /*now,  add the number of days added.  */
 nDate = date(,nBdays, 'B')                      /*calculate the new  date  (maybe).    */
 nTime = time('C', nMins, "M")                   /*    "      "   "   time     "        */

say aDate ' +  12 hours  ───► '  ndate ntime tz  /*display the new timestamp to console.*/
                                                 /*stick a fork in it,  we're all done. */
