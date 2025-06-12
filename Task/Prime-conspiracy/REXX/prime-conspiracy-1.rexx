/*REXX pgm shows a table of which last digit follows the previous last digit   */
/* for N primes                                                                */
Call time 'R'
Numeric Digits 12
Parse Arg n .                      /* N:  the number of primes to be looked at */
If n==''|n=="," Then               /* Not specified?                           */
  n=1000000                        /* Use the default                          */
w=length(n-1)                      /* W:  width used for formatting o*/

h=n*(2**max(4,(w%2+1)))            /* used as a rough limit for the sieve      */
h=h*1.2                            /* make sure it is large enough             */
prime.=1                           /* assume all numbers are prime             */
nn=1                               /* primes found so far {2 is the firt prime)*/
Do j=3 By 2 while nn<n
  If prime.j Then Do
    nn=nn+1                        /* bump the prime number counter.           */
    Do m=j*j To h By j+j
      prime.m=0                    /* strike odd multiples as composite        */
      End
    End
  End
Say 'Sieve of Eratosthenes finished' time('E') 'seconds'
Call time 'R'
frequency.=0                       /* initialize all the frequency counts      */
Say 'For' n 'primes used in this study:'
/*show hdr information about this run. */
r=2                                /* the last digit of the very 1st prime (2) */
nn=1                               /* the number of primes looked at           */
cnt.=0
cnt.2=1
Do i=3 By 2 While nn<n+1           /* Inspect all odd numbers                  */
  If prime.i Then Do               /* it is a prime number                     */
    nn=nn+1
    Parse Var i ''-1 x             /* get last digit of current prime          */
    cnt.x+=1                       /* bump last digit counter                  */
    frequency.r.x=frequency.r.x+1  /* bump the frequency counter               */
    r=x                            /* current becomes previous                 */
    End
  End
Say 'i='i 'largest prime'
Say 'h='h
Say                                /* display the results                      */
Do d=1 For 9
  If d//2|d==2 Then
    Say ''                         /* display a blank line (if appropriate)    */
  Do f=1 For 9
    If frequency.d.f>0 Then
      Say 'digit ' d '-->' f ' has a count of: ' right(frequency.d.f,w)||,
           ',  frequency of:' right(format(frequency.d.f/n*100,,4)'%.',10)
    End
  End
Say 'Frequency analysis:' time('E') 'seconds'
sum=0
Say 'last digit Number of occurrences'
Do i=1 To 9
  If cnt.i>0 Then
  Say '         'i format(cnt.i,8)
  sum+=cnt.i
  End
Say '         'format(sum,10)
