/*REXX pgm finds integers when shown in  decimal and hexadecimal  use the same numerals.*/
parse arg n cols .                               /*obtain optional argument from the CL.*/
if    n=='' |    n==","  then   n =  100000      /*Not specified?  Then use the default.*/
if cols=='' | cols==","  then cols=      10      /* "      "         "   "   "     "    */
w= 10                                            /*width of a number in any column.     */
                     @hHex= ' decimal integers when displayed in decimal and'      ,
                            "hexadecimal use the same numerals, where  N  < "   commas(n)
say ' index │'center(@hHex, 1 + cols*(w+1)     ) /*display the title for the output.    */
say '───────┼'center(""   , 1 + cols*(w+1), '─') /*   "     a   sep   "   "     "       */
dHex= 0;                               idx= 1    /*initialize # of high hexadecimal nums*/
$=                                               /*list of high hexadecimal #'s (so far)*/
    do j=0  for n;     h= d2x(j)                 /*search for high hexadecimal numbers. */
    if verify(j, h)>0  then iterate              /*Does the decimal and hexadecimal ··· */   /* ◄■■■■■■■■ a filter. */
    if verify(h, j)>0  then iterate              /*     ··· versions use same numerals? */   /* ◄■■■■■■■■ a filter. */
    dHex= dHex + 1                               /*bump number of decimal-hex numbers.  */
    $= $  right(commas(j), w)                    /*add a dec-hexadecimal number──► list.*/
    if dHex // cols \== 0          then iterate  /*have we populated a line of output?  */
    say center(idx, 7)'│'  substr($, 2);   $=    /*display what we have so far  (cols). */
    idx= idx + cols                              /*bump the  index  count for the output*/
    end   /*j*/

if $\==''  then say center(idx, 7)"│"  substr($, 2)  /*possible display residual output.*/
say '───────┴'center(""   , 1 + cols*(w+1), '─')     /*display the foot sep for output. */
say
say 'Found '        commas(dHex)       @hHex
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
