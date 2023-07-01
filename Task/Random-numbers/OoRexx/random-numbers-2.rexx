/*REXX pgm gens 1,000 normally distributed #s: mean=1, standard dev.=0.5*/
  pi=RxCalcPi()                     /* get value of pi                */
  Parse Arg n seed .                /* allow specification of N & seed*/
  If n==''|n==',' Then
    n=1000                          /* N  is the size of the array.   */
  If seed\=='' Then
    Call random,,seed               /* use seed for repeatable RANDOM#*/
  mean=1                            /* desired new mean (arith. avg.) */
  sd=1/2                            /* desired new standard deviation.*/
  Do g=1 For n                      /* generate N uniform random nums.*/
    n.g=random(0,1e5)/1e5           /* REXX gens uniform rand integers*/
    End

  Say '              old mean=' mean()
  Say 'old standard deviation=' stddev()
  Say
  Do j=1 To n-1 By 2
    m=j+1
                                    /*use Box-Muller method           */
    _=sd*sqrt(-2*ln(n.j))*cos(2*pi*n.m)+mean
    n.m=sd*sqrt(-2*ln(n.j))*sin(2*pi*n.m)+mean
    n.j=_
    End
  Say '              new mean=' mean()
  Say 'new standard deviation=' stddev()
  Exit
mean:
  _=0
  Do k=1 For n
    _=_+n.k
    End
  Return _/n
stddev:
  _avg=mean()
  _=0
  Do k=1 For n
    _=_+(n.k-_avg)**2
    End
  Return sqrt(_/n)

sqrt: Return RxCalcSqrt(arg(1))
ln:   Return RxCalcLog(arg(1))
cos:  Return RxCalcCos(arg(1),,'R')
sin:  Return RxCalcSin(arg(1),,'R')

:: requires rxmath library
