/*REXX program makes change from some amount with various specie (coins)*/
numeric digits 20                      /*be able to handle large amounts*/
parse arg N $                          /*obtain optional args from C.L. */
if N=''  then N=100                    /*Not specified?  Use $1 default.*/
if $=''  then $=1 5 10 25              /*Use penny/nickel/dime/quarter ?*/
coins=words($)                         /*count number of coins specified*/
!.=.                                   /*used for memoization for A & K.*/
                 do j=1  for coins     /*create a fast way of accessing.*/
                 $.j=word($,j)         /*define a stemmed array element.*/
                 end   /*j*/

say  'with an amount of '   N   " cents,  there are "    kaChing(N, coins)
say  'ways to make change with coins of the following denominations: '   $
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────KACHING subroutine──────────────────*/
kaChing: procedure expose $. !.; parse arg a,k     /*sub is recursive.  */
if a==0      then return 1                         /*unroll special case*/
if k==1      then return 1                         /*   "      "      " */
if k==2      then f=1                              /*handle special case*/
             else f=kaChing(a,k-1)                 /*recurse the amount.*/
if !.a.k\==. then return !.a.k                     /*found A & K before?*/
if a==$.k    then do; !.a.k=f+1; return f+1;  end  /*handle special case*/
if a <$.k    then do; !.a.k=f;   return f;    end  /*   "      "      " */
!.a.k=f + kaChing(a-$.k, k);     return !.a.k      /*compute,set,return.*/
