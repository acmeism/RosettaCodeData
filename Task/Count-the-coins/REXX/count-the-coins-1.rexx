/*REXX program counts the number of ways to make change with coins from an given amount.*/
numeric digits 20                                /*be able to handle large amounts of $.*/
parse arg N $                                    /*obtain optional arguments from the CL*/
if N='' | N=","    then N=100                    /*Not specified?  Then Use $1  (≡100¢).*/
if $='' | $=","    then $=1 5 10 25              /*Use penny/nickel/dime/quarter default*/
if left(N,1)=='$'  then N=100*substr(N,2)        /*the amount was specified in  dollars.*/
coins=words($)                                   /*the number of coins specified.       */
NN=N;              do j=1  for coins             /*create a fast way of accessing specie*/
                   _=word($,j)                   /*define an array element for the coin.*/
                   if _=='1/2'  then _=.5        /*an alternate spelling of a half-cent.*/
                   if _=='1/4'  then _=.25       /* "     "         "     " " quarter-¢.*/
                   $.j=_                         /*assign the value to a particular coin*/
                   end   /*j*/
_=n//100;                          cnt=' cents'  /* [↓]  is the amount in whole dollars?*/
if _=0  then do; NN='$' || (NN%100);  cnt=;  end /*show the amount in dollars, not cents*/
say 'with an amount of '      commas(NN)cnt",  there are "       commas( MKchg(N, coins) )
say 'ways to make change with coins of the following denominations: '    $
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: procedure;  parse arg _;           n=_'.9';     #=123456789;     b=verify(n,#,"M")
        e=verify(n,#'0',,verify(n,#"0.",'M'))-4
                    do j=e  to b  by -3;   _=insert(',',_,j);    end  /*j*/;      return _
/*──────────────────────────────────────────────────────────────────────────────────────*/
MKchg: procedure expose $.;       parse arg a,k  /*this function is invoked recursively.*/
         if a==0    then return 1                /*unroll for a special case of  zero.  */
         if k==1    then return 1                /*   "    "  "    "      "   "  unity. */
         if k==2    then f=1                     /*handle this special case   of  two.  */
                    else f=MKchg(a, k-1)         /*count,  and then recurse the amount. */
         if a==$.k  then return f+1              /*handle this special case of A=a coin.*/
         if a <$.k  then return f                /*   "     "     "      "   " A<a coin.*/
                         return f+MKchg(a-$.k,k) /*use diminished amount ($) for change.*/
