/*REXX program finds and displays N number of anti-primes (highly-composite) numbers.*/
Parse Arg N .                              /* obtain optional argument from the CL.  */
If N=='' | N=="," Then N=20                /* Not specified?  Then use the default.  */
maxD=0                                     /* the maximum number of divisors so far  */
Say '-index- --anti-prime--'               /* display a title For the numbers shown  */
nn=0                                       /* the count of anti-primes found  "  "   */
Do i=1 For 59 While nn<N                   /* step through possible numbers by twos  */
  d=nndivs(i)                              /* get nn divisors;                       */
  If d>maxD Then Do                        /* found an anti-prime nn set new maxD    */
    maxD=d
    nn=nn+1
    Say center(nn,7) right(i,10)           /* display the index and the anti-prime.  */
    End
  End /*i*/

Do i=60 by 20 While nn<N                   /* step through possible numbers by 20.   */
  d=nndivs(i)
  If d>maxD Then Do                        /* found an anti-prime nn set new maxD    */
    maxD=d
    nn=nn+1
    Say center(nn,7) right(i,10)           /* display the index and the anti-prime.  */
    End
  End /*i*/
Exit                                       /* stick a fork in it, we're all done.    */
/*-----------------------------------------------------------------------------------*/
nndivs: Procedure                          /* compute the number of proper divisors  */
  Parse Arg x
  If x<2 Then
    Return 1
  odd=x//2
  n=1                                      /* 1 is a proper divisor                  */
  Do j=2+odd by 1+odd While j*j<x          /* test all possible integers             */
                                           /* up To but excluding sqrt(x)            */
    If x//j==0 Then                        /* j is a divisor,so is x%j               */
      n=n+2
    End
  If j*j==x Then                           /* If x is a square                       */
    n=n+1                                  /* sqrt(x) is a proper divisor            */
  n=n+1                                    /* x is a proper divisor                  */
  Return n
