/*REXX pgm finds non─neg integers that are palindromes in base 2, 4, and 16, where N<25k*/
numeric digits 100                               /*ensure enough dec. digs for large #'s*/
parse arg n cols .                               /*obtain optional argument from the CL.*/
if    n=='' |    n==","  then   n = 25000        /*Not specified?  Then use the default.*/
if cols=='' | cols==","  then cols=    10        /* "      "         "   "   "     "    */
w= 10                                            /*width of a number in any column.     */
title= ' non-negative integers that are palindromes in base 2, 4, and 16,  where  N  < ' ,
       commas(n)
say ' index │'center(title, 1 + cols*(w+1)     ) /*display the title for the output.    */
say '───────┼'center(""   , 1 + cols*(w+1), '─') /*   "     a   sep   "   "     "       */
$= right(0, w+1)                                 /*list of numbers found  (so far).     */
found= 1                                         /*# of finds (so far), the only even #.*/
idx= 1                                           /*set the IDX  (index) to unity.       */
       do j=1  by 2  to n-1                      /*find int palindromes in bases 2,4,16.*/
          h= d2x(j)                              /*convert dec. # to hexadecimal.       */
       if h\==reverse(h)          then iterate   /*Hex    number not palindromic?  Skip.*/    /* ◄■■■■■■■■ a filter. */
          b= x2b( d2x(j) ) + 0                   /*convert dec. # to hex, then to binary*/
       if b\==reverse(b)          then iterate   /*Binary number not palindromic?  Skip.*/    /* ◄■■■■■■■■ a filter. */
          q= base(j, 4)                          /*convert a decimal integer to base 4. */
       if q\==reverse(q)          then iterate   /*Base 4 number not palindromic?  Skip.*/    /* ◄■■■■■■■■ a filter. */
       found= found + 1                          /*bump number of found such numbers.   */
       $= $  right( commas(j), w)                /*add the found number  ───►  $  list. */
       if found // cols \== 0     then iterate   /*have we populated a line of output?  */
       say center(idx, 7)'│'  substr($, 2); $=   /*display what we have so far  (cols). */
       idx= idx + cols                           /*bump the  index  count for the output*/
       end   /*j*/

if $\==''  then say center(idx, 7)"│"  substr($, 2)  /*possible display residual output.*/
say '───────┴'center(""   , 1 + cols*(w+1), '─')     /*display the foot sep for output. */
say
say 'Found '          found          title
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
/*──────────────────────────────────────────────────────────────────────────────────────*/
base:   procedure; parse arg #,t,,y;  @= 0123456789abcdefghijklmnopqrstuvwxyz /*up to 36*/
        @@= substr(@, 2);    do while #>=t;   y= substr(@, #//t + 1, 1)y;         #= # % t
                             end;                       return substr(@, #+1, 1)y
