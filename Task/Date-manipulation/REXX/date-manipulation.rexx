/*REXX pgm to add 12 hours to a date & time, showing the before & after.*/
 aDate = 'March 7 2009 7:30pm EST'
parse var aDate mon dd yyyy hhmm tz .  /*obtain the various parts&pieces*/
  mins = time('M',hhmm,'C')            /*get the # minutes past midnight*/
  mins = mins + (12*60)                /*add twelve hours to timestamp. */
 nMins = mins // 1440                  /*compute #min into same/next day*/
  days = mins %  1440                  /*compute number of days "added".*/
aBdays = date('B',dd left(mon,3) yyyy) /*# of base days since REXX epoch*/
nBdays = aBdays + days                 /*now, add the # of days "added".*/
 nDate = date(,nBdays,'B')             /*calculate the new date (maybe).*/
 nTime = time('C',nMins,'M')           /*    "      "   "  time    "    */
say aDate ' +  12 hours  ───► ' ndate ntime tz  /*display new timestamp.*/
                                       /*stick a fork in it, we're done.*/
