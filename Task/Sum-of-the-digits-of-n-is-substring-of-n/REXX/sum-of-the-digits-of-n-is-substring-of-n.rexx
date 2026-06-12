/*REXX pgm finds integers whose sum of decimal digits is a substring of  N,   N < 1000. */
parse arg hi cols .                              /*obtain optional argument from the CL.*/
if   hi=='' |   hi==","  then   hi= 1000         /*Not specified?  Then use the default.*/
if cols=='' | cols==","  then cols=   10         /* "      "         "   "   "     "    */
w= 10                                            /*width of a number in any column.     */
@sdsN= ' integers whose sum of decimal digis of  N  is a substring of  N,  where  N  < ' ,
                                                                           commas(hi)
if cols>0 then say ' index │'center(@sdsN,    1 + cols*(w+1)     )
if cols>0 then say '───────┼'center(""   ,    1 + cols*(w+1), '─')
finds= 0;                  idx= 1                /*initialize # of found numbers & index*/
$=                                               /*a list of found integers  (so far).  */
     do j=0  for hi;     #= sumDigs(j)           /*obtain sum of the decimal digits of J*/
     if pos(#, j)==0     then iterate            /*Sum of dec. digs in J?  No, then skip*/
     finds= finds + 1                            /*bump the number of found integers.   */
     if cols==0          then iterate            /*Build the list  (to be shown later)? */
     $= $  right( commas( commas(j) ),  w)       /*add a found number ──► the  $  list. */
     if finds//cols\==0  then iterate            /*have we populated a line of output?  */
     say center(idx, 7)'│'  substr($, 2);   $=   /*display what we have so far  (cols). */
     idx= idx + cols                             /*bump the  index  count for the output*/
     end   /*j*/

if $\==''  then say center(idx, 7)"│"  substr($, 2)  /*possible display residual output.*/
if cols>0 then say '───────┴'center(""   ,    1 + cols*(w+1), '─')
say
say 'Found '       commas(finds)      @sdsN
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
sumDigs:procedure; parse arg x 1 s 2;do j=2 for length(x)-1;s=s+substr(x,j,1);end;return s
