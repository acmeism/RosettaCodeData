/*REXX program sums the first   N   terms of    1/(k**2),    k=1 ──►  N.      */
parse arg N D .                        /*obtain optional arguments from C.L.  */
if N=='' | N==','  then N=1000         /*Not specified?  Then use the default.*/
if D=='' | D==','  then D=  60         /* "      "         "   "   "     "    */
numeric digits D                       /*use  D  digits  (nine is the default)*/
w=length(N)                            /*max width for the formatted output.  */
$=0                                    /*initialize the sum to zero.          */
      do k=1  for N                    /* [↓]  compute for   N   terms.       */
      $=$  +  1/k**2                   /*add a squared reciprocal to the sum. */
      parse var k s 2 m '' -1 e        /*obtain the start and end decimal digs*/
      if e\==0  then iterate           /*does K  end  with the dec digit  0 ? */
      if s\==1  then iterate           /*  "  " start   "   "   "    "    1 ? */
      if m\=0   then iterate           /*  "  " middle  contain any non-zero ?*/
      say  'The sum of'   right(k,w)  "terms is:"  $    /*display running sum.*/
      end   /*k*/
                                       /*stick a fork in it,  we're all done. */
