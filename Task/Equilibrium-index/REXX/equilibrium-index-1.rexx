/*REXX program finds the  equilibrium index  for a numeric array (list).*/
parse arg x                            /*get array's numbers from the CL*/
if x=''  then x=copies(' 7 -7',50)  7  /*Nothing given?  Generate a list*/
say '         array list: '  space(x)  /*echo the array list to screen. */
n=words(x)                             /*the number of words in the list*/
              do j=0  for n            /*0─start is for zero─based array*/
              A.j=word(x,j+1)          /*define the array element.      */
              end   /*j*/              /* [↑]  assign  A.0  A.1  A.3 ···*/
say                                    /*··· and also show a blank line.*/
ans=equilibriumIndex(n)                /*calculate the equilibrium Index*/
@indexes=word('indices index',1+(ans==1))     /*adjust for single index?*/
say 'equilibrium'  @indexes": "  ans   /*show equilibrium index/indices.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────EQUILIBRIUMINDEX subroutine─────────*/
equilibriumIndex:  procedure expose A. /*have the array  A.  be exposed.*/
parse arg top;  high=top-1             /*stemmed array   A.  starts at 0*/
q=                                     /*equilibrium indexes (so far).  */
        do e=0  to high                /*find various sums  (top/bot).  */
        sumB=0                         /*sum of  bottom part of the list*/
                do b=0  to e-1         /*add the    "     "   "  "    " */
                sumB=sumB + A.b        /*add this array element to sumB.*/
                end   /*b*/            /* [↑]  summation of bottom part.*/
        sumT=0                         /*sum of   top   part of the list*/
                do t=e+1  to high      /*add the   "      "   "  "    " */
                sumT=sumT + A.t        /*add this array element to sumT.*/
                end   /*t*/            /* [↑]  summation of the top part*/
        if sumB==sumT  then q=q e      /*if both sums equal, found one. */
        end         /*e*/              /* [↑]  add quilibrium to E list.*/
if q==''  then q="(none)"              /*adjust if no indices are found.*/
return strip(q)                        /*return the equilibrium list.   */
