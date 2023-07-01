/*REXX pgm shows current date:  yyyy-mm-dd  &  Dayofweek, Month dd, yyyy*/
   x = date('S')                       /*get current date as  yyyymmdd  */
yyyy = left(x,4)                       /*pick off year         (4 digs).*/
  dd = right(x,2)                      /*pick off day-of-month (2 digs).*/
  mm = substr(x,5,2)                   /*pick off month number (2 digs).*/
say yyyy'-'mm"-"dd                     /*yyyy-mm-dd with leading zeroes.*/

weekday = date('W')                    /*dayofweek (Monday or somesuch).*/
month   = date('M')                    /*Month     (August or somesuch).*/
zdd     = dd+0                         /*remove leading zero from  DD   */
say weekday',' month zdd"," yyyy       /*format date as:  Month dd, yyyy*/
                                       /*stick a fork in it, we're done.*/
