/*REXX pgm detects a cycle in an iterated function [F]               */
x=3; list=x; p.=0; p.x=1
Do q=2 By 1
  x=f(x)                           /* the next value                 */
  list=list x                      /* append it to the list          */
  If p.x>0 Then Do                 /* x was in the list              */
    cLen=q-p.x                     /* cycle length                   */
    Leave
    End
  p.x=q                            /* note position of x in the list */
  End
Say 'original list='  list ...
Say 'cycle length ='  cLen                   /*display the cycle len */
Say 'start index  ='  p.x-1 "  (zero based)" /*   "     "  index.    */
Say 'the sequence ='  subword(list,p.x,cLen) /*   "     "  sequence. */
Exit
/*-------------------------------------------------------------------*/
f: Return (arg(1)**2+1)// 255;                /*define the function F*/
