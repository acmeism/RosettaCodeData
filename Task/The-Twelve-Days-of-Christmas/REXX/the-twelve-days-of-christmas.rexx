/*REXX program displays the verses of the song:    "The 12 days of Christmas".          */
ordD= 'first second third fourth fifth sixth seventh eighth ninth tenth eleventh twelfth'
pad= left('', 20)                                /*used for indenting the shown verses. */
                   @.1= 'A partridge in a pear-tree.';   @.7 = "Seven swans a-swimming,"
                   @.2= 'Two Turtle Doves, and'      ;   @.8 = "Eight maids a-milking,"
                   @.3= 'Three French Hens,'         ;   @.9 = "Nine ladies dancing,"
                   @.4= 'Four Calling Birds,'        ;   @.10= "Ten lords a-leaping,"
                   @.5= 'Five Golden Rings,'         ;   @.11= "Eleven pipers piping,"
                   @.6= 'Six geese a-laying,'        ;   @.12= "Twelve drummers drumming,"
  do day=1  for 12
  say pad  'On the'   word(ordD, day)   "day of Christmas"    /*display line 1 prologue.*/
  say pad  'My True Love gave to me:'                         /*   "      "  2     "    */
              do j=day  by -1  to 1;       say pad @.j        /*   "    the daily gifts.*/
              end   /*j*/
  say                                            /*add a blank line between the verses. */
  end               /*day*/                      /*stick a fork in it,  we're all done. */
