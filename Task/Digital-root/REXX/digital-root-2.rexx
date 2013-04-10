/*REXX program calculates the  digital root  and  additive persistence. */
numeric digits 1000                                /*lets handle biguns.*/
say 'digital'                                      /*part of the header.*/
say '  root  persistence' center('number',79)      /*  "   "  "     "   */
say '═══════ ═══════════' center(''      ,79,'═')  /*  "   "  "     "   */
call digRoot       627615
call digRoot        39390
call digRoot       588225
call digRoot 393900588225
call digRoot 899999999999999999999999999999999999999999999999999999999999999999999999999999999
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────DIGROOT subroutine──────────────────*/
digRoot: procedure;  parse arg x 1 ox  /*get the num, save as original. */
  do pers=0 while length(x)\==1;  r=0  /*keep summing until digRoot=1dig*/
       do j=1 for length(x)            /*add each digit in the number.  */
       r=r+substr(x,j,1)               /*add a digit to the digital root*/
       end   /*j*/
  x=r                                  /*'new' num, it may be multi-dig.*/
  end        /*pers*/
say center(x,7) center(pers,11) ox     /*show a nicely formatted line.  */
return
