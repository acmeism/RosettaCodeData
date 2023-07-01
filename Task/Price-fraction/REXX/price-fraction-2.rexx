/* REXX ***************************************************************
* Inspired by some other solutions tested with version 1 (above)
* 20.04.2013 Walter Pachl
* 03.11.2013 -"- move r. computation (once is enough)
**********************************************************************/
rl='0.10 0.18 0.26 0.32 0.38 0.44 0.50 0.54 0.58 0.62',
   '0.66 0.70 0.74 0.78 0.82 0.86 0.90 0.94 0.98 1.00'
Do i=1 To 20
  Parse Var rl r.i rl
  End
Do x=0 To 1 By 0.01
  old=adjprice(x)
  new=adjprice2(x)
  If old<>new Then tag='??'
  else tag=''
  Say x old new  tag
  End
Exit

adjprice2: Procedure Expose r.
  i=((100*arg(1)-1)%5+1)
  Return r.i
