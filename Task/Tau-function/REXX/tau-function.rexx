/* REXX program counts the number of divisors (tau,cr sigma_0)                    */
/* for a range of numbers                                                         */
Parse Arg lo hi cols .                     /*obtain optional argument from the CL.*/
If   lo=='' |   lo==',' Then lo=1          /*Not specified?  Then use the default.*/
If   hi=='' |   hi==',' Then hi=lo+100-1   /*Not specified?  Then use the default.*/
If cols==''             Then cols=20       /* "      "         "   "   "     "    */
w=2+(hi>45359)                             /* width of columns tau(4mns5360)=100  */
Say 'The number of divisors (tau) from' lo 'to' hi '(inclusive):'
Say ''
Say '-number' center(' tau (number of divisors) ',cols*(w+1)+1,'-')
line=''
c=0
index=lo
Do j=lo To hi
  c=c+1
  line=line right(tau(j),w)                /* add a tau number to the output line. */
  If c//cols=0  Then Do                    /* line has cols numbers                */
    Say center(index,7) line
    line=''
    cnt=0
    Index=index+cols
    End
  End   /*j*/
If line\=='' Then
  Say center(index,7) line                 /*there any residuals left To display ? */
Exit 0                                     /*stick a fork in it,  we're all done.  */
/*---------------------------------------------------------------------------------*/
tau: Procedure
  Parse Arg x
  If x<6 Then                              /* some low numbers are handled special */
    Return 2+(x==4)-(x==1)
  tau=0
  odd=x//2
  Do j=1 by 1 While j*j<x
    If odd & j//2=0 Then                   /* even j can't be a divisor of an odd x*/
      Iterate
    If x//j==0  Then                       /* if no remainder, then found a divisor*/
      tau=tau+2                            /* bump n of divisors                   */
    End
  If j*j=x Then                            /* x is a square                        */
    tau=tau+1                              /* its root is a divisor                */
  Return tau
