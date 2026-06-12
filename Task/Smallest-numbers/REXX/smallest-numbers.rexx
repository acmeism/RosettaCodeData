/*REXX pgm finds the  smallest positive integer  K  where   K**K   contains  N,  N < 51 */
numeric digits 200                               /*ensure enough decimal digs for  k**k */
parse arg hi cols .                              /*obtain optional argument from the CL.*/
if   hi=='' |   hi==","  then   hi= 51           /*Not specified?  Then use the default.*/
if cols=='' | cols==","  then cols= 10           /* "      "         "   "   "     "    */
w= 6                                             /*width of a number in any column.     */
title=' smallest positive integer  K  where  K**K  contains  N,   0  ≤  N  < '  commas(hi)
say '  N  │'center(title, 5 + cols*(w+1)     )   /*display the   title   of the output. */
say '─────┼'center(""   , 5 + cols*(w+1), '─')   /*   "     "  separator  "  "     "    */
u= 0;                                    !.= .   /*number of unique #'s found; semaphore*/
$=;                                      idx= 0  /*define  $  output list;  index to  0.*/
     do j=0  for hi                              /*look for a power of K that contains N*/
                    do k=1  until pos(j, k**k)>0 /*calculate a bunch of powers  (K**K). */
                    end   /*k*/
     if !.k==.  then do; u= u+1;  !.k=;  end     /*Is unique?  Then bump unique counter.*/
     c= commas(k)                                /*maybe add commas to the powe of six. */
     $= $ right(c, max(w, length(c) ) )          /*add a  K (power) ──► list, allow big#*/
     if (j+1)//cols\==0  then iterate            /*have we populated a line of output?  */
     say center(idx, 5)'│'substr($, 2);     $=   /*display what we have so far  (cols). */
     idx= idx + cols                             /*bump the  index  count for the output*/
     end   /*j*/

if $\==''  then say center(idx, 5)"│"substr($,2) /*possible display any residual output.*/
say '─────┴'center(""   , 5 + cols*(w+1), '─')   /*   "     "  separator  "  "     "    */
say
say commas(u)  ' unique numbers found.'
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
