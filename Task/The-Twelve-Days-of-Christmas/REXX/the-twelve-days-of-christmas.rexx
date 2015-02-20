/*REXX program displays the verses of song  "The 12 days of Christmas". */
Nth='first second third fourth fifth sixth seventh eighth ninth tenth eleventh twelfth'
pad=left('',20)

     g.1= 'A partridge in a pear-tree.'; g.7 = 'Seven swans a-swimming,'
     g.2= 'Two Turtle Doves, and'      ; g.8 = 'Eight maids a-milking,'
     g.3= 'Three French Hens,'         ; g.9 = 'Nine ladies dancing,'
     g.4= 'Four Calling Birds,'        ; g.10= 'Ten lords a-leaping,'
     g.5= 'Five Golden Rings,'         ; g.11= 'Eleven pipers piping,'
     g.6= 'Six geese a-laying,'        ; g.12= 'Twelve drummers drumming,'

  do day=1  for 12
  say pad 'On the' word(Nth,day) 'day of Christmas'  /*prologue, line 1.*/
  say pad 'My True Love gave to me:'                 /*prologue, line 2.*/
          do j=day  to 1  by -1;  say pad g.j;  end  /*display the gifts*/
  say                                  /*add a blank line between verses*/
  end       /*day*/                    /*stick a fork in it, we're done.*/
