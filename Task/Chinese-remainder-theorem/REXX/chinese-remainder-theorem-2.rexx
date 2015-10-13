/*REXX program demonstrates Sun Tzu's (or Sunzi's)  Chinese Remainder Theorem.*/
parse arg Ns As .                      /*get optional arguments from the C.L. */
if Ns==''  then Ns = '3,5,7'           /*Ns not specified?   Then use default.*/
if As==''  then As = '2,3,2'           /*As  "      "          "   "      "   */
     say 'Ns: ' Ns
     say 'As: ' As;            say
Ns=space(translate(Ns,,','));  #=words(Ns)     /*elide any superfluous blanks.*/
As=space(translate(As,,','));  _=words(As)     /*  "    "       "        "    */
if #\==_   then do;  say  "size of number sets don't match.";   exit 131;    end
if #==0    then do;  say  "size of the  N  set isn't valid.";   exit 132;    end
if _==0    then do;  say  "size of the  A  set isn't valid.";   exit 133;    end
N=1                                    /*the product─to─be  for  prod(n.j).   */
      do j=1  for #                    /*process each number for  As  and Ns. */
      n.j=word(Ns,j);  N=N*n.j         /*get an  N.j  and calculate product.  */
      a.j=word(As,j)                   /* "   "  A.j  from the  As  list.     */
      end   /*j*/
@.=                                    /* [↓]  converts congruences ───► sets.*/
      do i=1  for #;  _=a.i;  @.i._=a.i;  p=a.i
        do N; p=p+n.i;  @.i.p=p;  end  /*build a (array) list of modulo values*/
      end   /*i*/
                                       /* [↓]  find common number in the sets.*/
  do   x=1  for N;  if @.1.x==''  then iterate             /*locate a number. */
    do v=2  to #;   if @.v.x==''  then iterate x;  end     /*Is in all sets ? */
  say 'found a solution with X=' x     /*display one possible solution.       */
  exit                                 /*stick a fork in it,  we're all done. */
  end   /*x*/

say 'no solution found.'               /*oops, announce that solution ¬ found.*/
