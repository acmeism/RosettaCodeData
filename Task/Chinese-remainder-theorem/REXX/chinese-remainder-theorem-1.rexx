/*REXX program uses the Chinese Remainder Theorem  (Sun Tzu).           */
parse arg Ns As .                      /*get optional arguments from CL.*/
if Ns==''  then Ns = '3,5,7'           /*Ns not specified?  Use default.*/
if As==''  then As = '2,3,2'           /*As  "      "        "     "    */
Ns=space(translate(Ns,,','));  #=words(Ns)    /*elide superfluous blanks*/
As=space(translate(As,,','));  _=words(As)    /*  "        "         "  */
if #\==_   then do; say "size of number sets don't match.";  exit 131; end
if #==0    then do; say "size of the  N  set isn't valid.";  exit 132; end
if _==0    then do; say "size of the  A  set isn't valid.";  exit 133; end
N=1                                    /*the product─to─be for prod(n.j)*/
      do j=1  for #                    /*process each number for As, Ns.*/
      n.j=word(Ns,j);  N=N*n.j         /*get an  N.j  and calculate prod*/
      a.j=word(As,j)                   /* "   "  A.j  from the  As.     */
      end   /*j*/

  do    x=1  for N                     /*use a simple algebraic method. */
     do i=1  for #                     /*process each   A.i   number.   */
     if x//n.i\==a.i  then iterate x   /*is the modulus correct for F ? */
     end   /*i*/                       /* [↑]  limit solution to product*/
  say 'found a solution with x=' x     /*announce a possible solution.  */
  exit                                 /*stick a fork in it, we're done.*/
  end   /*x*/
                                       /*stick a fork in it, we're done.*/
say 'no solution found.'               /*oops, announce that  ¬ found.  */
