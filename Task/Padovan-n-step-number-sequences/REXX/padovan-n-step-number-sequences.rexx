/*REXX program computes and shows the Padovan sequences for  M  steps  for  N  numbers. */
parse arg n m .                                  /*obtain optional arguments from the CL*/
if  n=='' |  n==","  then  n= 15                 /*Not specified?  Then use the default.*/
if  m=='' |  m==","  then  m=  8                 /* "      "         "   "   "     "    */
w.= 1                                            /*W.c:  the maximum width of a column. */
        do #=2  for m-1
        @.= 0;    @.0= 1;    @.1= 1;    @.2= 1   /*initialize 3 terms of the Padovan seq*/
        $= @.0                                   /*initials the list with the zeroth #. */
               do k=2  for  n-1;      z= pd(k-1)
               w.k= max(w.k, length(z));  $= $ z /*find maximum width for a specific col*/
               end   /*k*/
        $.#= $                                   /*save each unaligned line for later.  */
        end          /*#*/
oW= 1
        do col=1  for n;  oW= oW + w.col + 1     /*add up the width of each column.     */
        end   /*col*/
                    iW= length(m) + 2;       pad= left('', 20*(n<21))    /*maybe indent.*/
say pad center('M', iW, " ")"│"center('first ' n " Padovan sequence with step  M", oW)
say pad center('',  iW, "─")"┼"center('',  oW,  "─")

        do out=2  for m-1;   $=                  /*align columnar elements for outputs. */
             do j=1  for n;  $= $ right(word($.out, j),  w.j)      /*align the columns. */
             end     /*j*/
        say pad center(out,length(m)+2)'│'$      /*display a line of columnar elements. */
        end          /*out*/

say pad center('',  length(m)+2, "─")"┴"center('',  oW,  "─")
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
pd:    procedure expose @. #; parse arg x;  if @.x\==0  then return @.x   /*@.x defined?*/
                    do k=1  for  #;   _= x-1-k;    @.x= @.x + @._;    end;      return @.x
