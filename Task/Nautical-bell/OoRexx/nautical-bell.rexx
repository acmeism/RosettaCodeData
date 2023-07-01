/*REXX pgm beep's "bells" (using PC speaker) when running (perpetually).*/
  Parse Arg msg
  If msg='?' Then Do
    Say 'Ring a nautical bell'
    Exit
    End
  Signal on Halt                   /* allow a clean way to stop prog.*/
  Do Forever
    Parse Value time() With hh ':' mn ':' ss
    ct=time('C')
    hhmmc=left(right(ct,7,0),5)        /* HH:MM (leading zero).      */
    If msg>'' Then
      Say center(arg(1) ct time(),79)  /* echo arg1 with time ?      */
    If ss==00 & ( mn==00 | mn==30 ) Then Do /*It's time to ring bell */
      dd=dd(hhmmc)                     /* compute number of times    */
      If msg>'' Then
        Say center(dd "bells",79)      /* echo bells?                */
      Do k=1 For dd
        Call beep 650,500
        Call syssleep 1+(k//2==0)
        End
      Call syssleep 60                 /* ensure don't re-peel.      */
      End
    Else
      Call syssleep (60-ss)
    End
/* test
time:
If arg(1)='C' Then
  res='8:30am'
Else
  res='08:30:00'
Return res
*/

dd: Parse Arg hhmmc
Parse Var hhmmc hh +2 ':' mm .
h=hh//4
If h=0 Then
  If mm=00 Then res=8
  Else res=1
Else
  res=2*h+(mm=30)
Return res

halt:
