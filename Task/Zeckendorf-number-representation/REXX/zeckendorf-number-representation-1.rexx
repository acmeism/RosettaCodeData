/* REXX ***************************************************************
* 11.10.2012 Walter Pachl
**********************************************************************/
fib='13 8 5 3 2 1'
Do i=6 To 1 By -1                   /* Prepare Fibonacci Numbers     */
  Parse Var fib f.i fib             /* f.1 ... f.7                   */
  End
Do n=0 To 20                        /* for all numbers in the task   */
  m=n                               /* copy of number                */
  r=''                              /* result for n                  */
  Do i=6 To 1 By -1                 /* loop through numbers          */
    If m>=f.i Then Do               /* f.i must be used              */
      r=r||1                        /* 1 into result                 */
      m=m-f.i                       /* subtract                      */
      End
    Else                            /* f.i is larger than the rest   */
      r=r||0                        /* 0 into result                 */
    End
  r=strip(r,'L','0')                /* strip leading zeros           */
  If r='' Then r='0'                /* take care of 0                */
  Say right(n,2)':  'right(r,6)     /* show result                   */
  End
