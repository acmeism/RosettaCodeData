/*REXX program calculates and displays a specific value (or a range of)  partitionsP(N).*/
numeric digits 1000                              /*able to handle some ginormous numbers*/
parse arg lo hi .                                /*obtain optional arguments from the CL*/
if lo=='' | lo==","  then lo=  0                 /*Not specified?  Then use the default.*/
if hi=='' | hi==","  then hi= lo                 /* "      "         "   "   "     "    */
@.= 0;   @.0= 1; @.1= 1; @.2= 2; @.3= 3; @.4= 5  /*default values for some low numbers. */
!.= @.;  !.1= 1; !.3= 1; !.5= 1; !.7= 1; !.9= 1  /*   "       "    "  all the 1─digit #s*/
w= length( commas(hi) )                          /*W:  is used for aligning the index.  */

       do j=lo  to hi                            /*compute a range of  partitionsP.     */
       say right( commas(j), w)    ' '     commas( partP(j) )
       end   /*j*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
/*──────────────────────────────────────────────────────────────────────────────────────*/
partP:  procedure expose @. !.;  parse arg n     /*obtain number (index) for computation*/
        if @.n\==0  then return @.n              /*Is it already computed?   Return it. */
        #= 0                                               /*initialize part  P  number.*/
               do k=1  for n;  z= n  - (k+k+k - 1) * k % 2 /*compute the partition P num*/
               if z<0  then leave                          /*Is Z negative?  Then leave.*/
               if @.z==0  then x= partP(z)                 /*use recursion if not known.*/
                          else x= @.z                      /*use the pre─computed number*/
               z= z - k                                    /*subtract index (K) from Z. */
               if z<0     then y= 0                        /*Is Z negative? Then set Y=0*/
                          else if @.z==0  then y= partP(z) /*use recursion if not known.*/
                                          else y= @.z      /*use the pre─computed number*/
               parse var   k   ''  -1  _                   /*obtain K's last decimal dig*/
               if !._     then #= # +  x + y               /*Odd? Then   sum    X and Y.*/
                          else #= # - (x + y)              /*Even?  "  subtract "  "  " */
               end   /*k*/
        @.n= #;                   return #       /*define and return partitionsP of  N. */
