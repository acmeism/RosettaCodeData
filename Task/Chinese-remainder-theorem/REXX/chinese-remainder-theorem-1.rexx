/*REXX program demonstrates  Sun Tzu's  (or Sunzi's)  Chinese Remainder  Theorem.       */
parse arg Ns As .                                /*get optional arguments from the C.L. */
if Ns=='' | Ns==","  then Ns = '3,5,7'           /*Ns not specified?   Then use default.*/
if As=='' | As==","  then As = '2,3,2'           /*As  "      "          "   "      "   */
       say 'Ns: ' Ns
       say 'As: ' As;                   say
Ns=space(translate(Ns, , ','));  #=words(Ns)     /*elide any superfluous blanks from N's*/
As=space(translate(As, , ','));  _=words(As)     /*  "    "       "        "      "  A's*/
if #\==_   then do;  say  "size of number sets don't match.";   exit 131;    end
if #==0    then do;  say  "size of the  N  set isn't valid.";   exit 132;    end
if _==0    then do;  say  "size of the  A  set isn't valid.";   exit 133;    end
N=1                                              /*the product─to─be  for  prod(n.j).   */
      do j=1  for #                              /*process each number for  As  and Ns. */
      n.j=word(Ns,j);  N=N*n.j                   /*get an  N.j  and calculate product.  */
      a.j=word(As,j)                             /* "   "  A.j  from the  As  list.     */
      end   /*j*/

      do    x=1  for N                           /*use a simple algebraic method.       */
         do i=1  for #                           /*process each   N.i  and  A.i  number.*/
         if x//n.i\==a.i  then iterate x         /*is modulus correct for the number X ?*/
         end   /*i*/                             /* [↑]  limit solution to the product. */
      say 'found a solution with X='   x         /*display one possible solution.       */
      exit                                       /*stick a fork in it,  we're all done. */
      end      /*x*/

say 'no solution found.'                         /*oops, announce that solution ¬ found.*/
