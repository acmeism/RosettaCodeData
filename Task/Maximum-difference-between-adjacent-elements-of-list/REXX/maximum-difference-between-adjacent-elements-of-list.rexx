/*REXX program finds/displays the maximum difference between adjacent elements of a list*/
parse arg $                                      /*obtain optional arguments from the CL*/
if $='' | S==","  then $= ,                      /*Not specified?  Then use the default.*/
     '1,8,2,-3,0,1,1,-2.3,0,5.5,8,6,2,9,11,10,3' /*commas are optional;  blanks are OK. */
w= 0                                             /*the maximum width of any element num.*/
$= translate($, , ',')                           /*elide optional commas between numbers*/
#= words($)                                      /*number of elements in the  $  list.  */
             do i=1  for words($); x= word($, i) /*examine each element, ensure a number*/
             @.i= x;     w= max(w, length(x) )   /*assign element #; find maximum width.*/
             if datatype(x, 'N')  then iterate   /*Is it numeric?   Yes, then continue. */
             say '***error***  element #'i    " isn't numeric: "    x
             exit 13
             end   /*i*/
n= 0                                             /*N:   # sets of (difference) elements.*/
if #<2  then do;   say '***error***  not enough elements were specified,  minimum is two.'
                   exit 13
             end
say '   list  of elements: '    space($)         /*show the  list  of  numbers  in list.*/
say '  number of elements: '    #                /*show  "  number  "  elements  "   "  */
d= -1;                                           /*d:  maximum difference found (so far)*/
        do j=1  for #-1;   jp= j + 1;   a= @.j   /*obtain the  "A"  element.            */
                                        b= @.jp  /*   "    "   "B"     "                */
        newD= abs(a - b)                         /*obtain difference between 2 elements.*/
        if newD<d  then iterate                  /*Is this  not  a new max difference ? */
        d= newD                                  /*assign new maximum difference,  and  */
        n= n + 1                                 /*bump the # of (difference) sets.     */
        aa.n= a;        bb.n= b                  /*  the elements that had the max diff.*/
        end   /*j*/
say
say 'The maximum difference of the elements in the list is:  '     d
        do k=1  for n
        say 'and is between the elements: '   right(aa.k, w)    " and "     right(bb.k, w)
        end   /*k*/
exit 0                                           /*stick a fork in it,  we're all done. */
