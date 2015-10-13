/*REXX program displays the verses of the song:   "The 12 days of Christmas". */
@='first second third fourth fifth sixth seventh eighth ninth tenth eleventh twelfth'
pad=left('',20)                         /*used for indenting the shown verses.*/

       g.1= 'A partridge in a pear-tree.';     g.7 = 'Seven swans a-swimming,'
       g.2= 'Two Turtle Doves, and'      ;     g.8 = 'Eight maids a-milking,'
       g.3= 'Three French Hens,'         ;     g.9 = 'Nine ladies dancing,'
       g.4= 'Four Calling Birds,'        ;     g.10= 'Ten lords a-leaping,'
       g.5= 'Five Golden Rings,'         ;     g.11= 'Eleven pipers piping,'
       g.6= 'Six geese a-laying,'        ;     g.12= 'Twelve drummers drumming,'

  do day=1  for 12
  say pad 'On the' word(@,day) 'day of Christmas'    /*display line 1 prologue*/
  say pad 'My True Love gave to me:'                 /*   "      "  2     "   */
        do j=day  to 1  by -1;   say pad g.j;   end  /*   "    the daily gifts*/
  say                                  /*add a blank line between the verses. */
  end   /*day*/                        /*stick a fork in it,  we're all done. */
