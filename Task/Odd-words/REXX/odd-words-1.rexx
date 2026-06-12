/* REXX */
fid='d:\unix.txt'
ww.=0   /* ww.*  the words to be analyzed     */
w.=0    /* w.word = 1 if word is in unix.txt  */
Do While lines(fid)>0
  l=linein(fid)     /* a word                 */
  ll=length(l)
  w.l=1             /*  word is in unix.txt   */
  If ll>=9 Then Do  /* worth to be analyzed   */
    z=ww.0+1        /* add it to the list     */
    ww.z=l
    ww.0=z
    End
  End
n=0
Do i=1 To ww.0
  wodd=wodd(ww.i)
  If w.wodd Then Do
    n=n+1
    Say format(n,3) left(ww.i,10) wodd
    End
  End
Exit
wodd: Procedure
/* use odd indexed letters */
  Parse Arg w
  wo=''
  Do i=1 To length(w)
    If i//2=1 Then
      wo=wo||substr(w,i,1)
    End
  Return wo
