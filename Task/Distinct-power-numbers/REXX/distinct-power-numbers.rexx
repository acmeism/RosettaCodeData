/*REXX pgm finds and displays distinct power integers:  a^b,  where a and b are 2≤both≤5*/
parse arg lo hi cols .                           /*obtain optional arguments from the CL*/
if   lo=='' |   lo==","  then   lo=  2           /*Not specified?  Then use the default.*/
if   hi=='' |   hi==","  then   hi=  5           /* "      "         "   "   "     "    */
if cols=='' | cols==","  then cols= 10           /* "      "         "   "   "     "    */
w= 11                                            /*width of a number in any column.     */
title= ' distinct power integers, a^b, where  a  and  b  are: '    lo    "≤ both ≤"    hi
say ' index │'center(title,  1 + cols*(w+1)     )
say '───────┼'center(""   ,  1 + cols*(w+1), '─')
@.= .;                      $$=                  /*the default value for the  @.  array.*/
        do    a=lo  to  hi                       /*traipse through  A  values (LO──►HI).*/
           do b=lo  to  hi                       /*   "       "     B     "     "    "  */
           x= a ** b;   if @.x\==.  then iterate /*Has it been found before?  Then skip.*/
           @.x= x;      $$= $$  x                /*assign power product; append to  $$  */
           end   /*b*/
        end      /*a*/
$=;                             idx= 1           /*$$: a list of distinct power integers*/
    do j=1  while words($$)>0;  call getMin $$   /*obtain smallest number in the $$ list*/
    $= $  right(commas(z), max(w, length(z) ) )  /*add a distinct power number ──► list.*/
    if j//cols\==0  then iterate                 /*have we populated a line of output?  */
    say center(idx, 7)'│'  substr($, 2);   $=    /*display what we have so far  (cols). */
    idx= idx + cols                              /*bump the  index  count for the output*/
    end   /*j*/

if $\==''  then say center(idx, 7)"│"  substr($, 2)  /*possible display residual output.*/
say '───────┴'center(""   ,  1 + cols*(w+1), '─')
say
say 'Found '       commas(j-1)         title
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
/*──────────────────────────────────────────────────────────────────────────────────────*/
getMin: parse arg z .;  p= 1;   #= words($$)               /*assume min;  # words in $$.*/
          do m=2  for #-1;    a= word($$, m);    if a>=z  then iterate;     z= a;     p= m
          end   /*m*/;    $$= delword($$, p, 1);    return /*delete the smallest number.*/
