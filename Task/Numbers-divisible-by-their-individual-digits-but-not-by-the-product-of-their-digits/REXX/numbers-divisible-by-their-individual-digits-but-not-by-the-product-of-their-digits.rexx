/*REXX pgm finds integers divisible by its individual digits, but not by product of digs*/
parse arg hi cols .                              /*obtain optional argument from the CL.*/
if   hi=='' |   hi==","  then   hi= 1000         /*Not specified?  Then use the default.*/
if cols=='' | cols==","  then cols=   10         /* "      "         "   "   "     "    */
w= 10                                            /*width of a number in any column.     */
                    title= ' base ten integers  < '   commas(hi)   " that are divisible" ,
                           'by its digits, but not by the product of its digits'
if cols>0 then say ' index │'center(title,   1 + cols*(w+1)     )
if cols>0 then say '───────┼'center(""   ,   1 + cols*(w+1), '─')
finds= 0;                 idx= 1                 /*initialize # of found numbers & index*/
$=                                               /*a list of integers found  (so far).  */
     do j=1  for hi-1;    L= length(j);    != 1  /*search for integers within the range.*/
     if pos(0, j)>0  then iterate                /*Does J have a zero?  Yes, then skip. */      /* ◄■■■■■■■■ a filter. */
            do k=1  for L;    x= substr(j, k, 1) /*extract a single decimal digit from J*/
            if j//x\==0   then iterate j         /*J ÷ by this digit?  No, then skip it.*/      /* ◄■■■■■■■■ a filter. */
            != ! * x                             /*compute the running product of digits*/
            end   /*k*/
     if j//!==0           then iterate           /*J ÷ by its digit product?  Yes, skip.*/      /* ◄■■■■■■■■ a filter. */
     finds= finds + 1                            /*bump the number of  found  integers. */
     if cols<0            then iterate           /*Build the list  (to be shown later)? */
     $= $ right( commas(j), w)                   /*add the number found to the  $  list.*/
     if finds//cols\==0   then iterate           /*have we populated a line of output?  */
     say center(idx, 7)'│'  substr($, 2);   $=   /*display what we have so far  (cols). */
     idx= idx + cols                             /*bump the  index  count for the output*/
     end   /*j*/

if $\==''  then say center(idx, 7)"│"  substr($, 2)  /*possible display residual output.*/
if cols>0 then say '───────┴'center(""                         ,  1 + cols*(w+1), '─')
say
say 'Found '       commas(finds)       title
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
