/*REXX program finds and displays  Wieferich primes  which are under a specified limit N*/
Parse arg n .                                    /*obtain optional argument from the CL.*/
If n=='' | n==","  Then n=5000                   /*Not specified?  Then use the default.*/
Numeric Digits 5000
Numeric Digits max(9,length(2**n))               /*calculate nr of decimal digits needed*/
call genP                                        /*build array of semaphores for primes.*/
/****************
Do i=1 To nn
  Say i pr.i sq.i
  End
****************/
title=' Wieferich primes that are  < 'commas(n)  /*title for the output.                */
w=length(title)+2                                /*width of field for the primes listed.*/
Say ' index |'center(title,w)                    /*display the title for the output.    */
Say '-------+'center('',w,'-')                   /*  "     a   sep   "   "     "        */
found=0                                          /*initialize number of Wieferich primes*/
Do j=1 To nn
  p=pr.j                                         /*search for Wieferich primes in range.*/
  If (2**(p-1)-1)//p**2=0 Then Do                /* P**2 evenly divides  2**(P-1)-1     */
    found=found+1                                /*bump the counter of Wieferich primes.*/
    Say center(found,7)'|' center(commas(p),w)   /*display the Wieferich prime.*/
    End
  End

Say '--------'center(""   , w, '-')              /*display a  foot sep  for the output. */
Say 'Found ' commas(found) title                 /*   "    "  summary    "   "     "    */
Exit 0                                           /*stick a fork in it,  we're all done. */
/*--------------------------------------------------------------------------------------*/
commas: Parse arg ?; Do jc=length(?)-3 To 1 by -3; ?=insert(',', ?, jc); End; Return ?
/*--------------------------------------------------------------------------------------*/
genP:
/*****************************************************************************************
* Compute all primes less than n+1
* Output: nn - the number of primes found
*         pr.i The i-th prime
*         sq.i the square of pr.i
*****************************************************************************************/
  primes='2 3 5 7 11'
  nn=0
  Do while primes>''                             /* for efficiency note a few primes    */
    Parse Var primes w primes
    Call store w
    End
  Do j=pr.nn+2 by 2 To n                         /* look at odd numbers up to n         */
    If right(j,1)<>5 Then                        /* number does not end in 5            */
       If j//3<>0 Then                           /*    "   is not a multiple of 3       */
         If j//7<>0 Then Do                      /*    "   is not a multiple of 7       */
           Do k=5 while sq.k<=j                  /* check all primes up to sqrt(j)      */
             If j//pr.k==0 Then iterate j        /* if this is a divisor: j is not prime*/
             End
           Call store j                          /* j is a prime number. store it       */
           End
    End
  Return

store:
  Parse Arg w
  nn=nn+1
  pr.nn=w
  sq.nn=w**2
  Return
