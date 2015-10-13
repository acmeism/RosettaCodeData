/*REXX program finds the  averages/arithmetic mean of several lists (vectors).*/
                               @.1 =   10 9 8 7 6 5 4 3 2 1
                               @.2 =   10 9 8 7 6 5 4 3 2 1 0 0 0 0  .11
                               @.3 =  '10 20 30 40 50  -100  4.7  -11e2'
                               @.4 =  '1 2 3 4  five  6 7 8 9  10.1.  ±2'
                               @.5 =  'World War I  &  World War II'
                               @.6 =                          /*a null value. */
     do j=1  for 6
     say 'numbers = '   @.j;   say "average = "   avg(@.j);   say copies('═',60)
     end   /*t*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
avg: procedure;  parse arg x;     #=words(x);    $=0   /*#:  number of items. */
if #==0  then return  'N/A: ───[null vector.]'         /*No words?  Return N/A*/

     do k=1  for #;      _=word(x,k)                        /*obtain a number.*/
     if datatype(_,'N')  then do;  $=$+_;  iterate;  end    /*if numeric, add.*/
     say left('',20) "***error!*** non-numeric: " _; #=#-1  /*error; adjust #.*/
     end   /*k*/

if #==0  then return  'N/A: ───[no numeric values.]'   /*No nums?  Return N/A.*/
return $/max(1,#)                                      /*return the average.  */
