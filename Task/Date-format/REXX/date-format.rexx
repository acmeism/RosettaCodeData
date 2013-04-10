/*show current date in yyyy-mm-dd and also Dayofweek, Month dd, yyyy*/
x=date('s')                            /* yyyymmdd */
yyyy=left(x,4)                         /* pick off the year. */
dd=right(x,2)                          /* pick off the day of month */
say yyyy'-'substr(x,5,2)"-"dd          /*yyyy-mm-dd with leading 0s */

weekday  =date('w')                    /* Dayofweek  (Saturday)     */
month    =date('m')                    /* Month      (December)     */
zdd      =dd+0                         /* remove leading zero of DD */
say weekday',' month zdd"," yyyy       /*Month dd, yyyy             */
                                       /*stick a fork in it, we're done.*/
