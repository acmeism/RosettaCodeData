/* REXX */
fid='d:\unix.txt'
cnt.=0  /* cnt.n -> words of length n         */
ww.=0   /* ww.*  the words to be analyzed     */
w.=0    /* w.word = 1 if word is in unix.txt  */
Do While lines(fid)>0
  l=linein(fid)     /* a word                 */
  ll=length(l)      /* its length             */
  cnt.ll=cnt.ll+1   /* count it               */
  w.l=1             /*  word is in unix.txt   */
  If ll>=6 Then Do  /* worth to be analyzed   */
    z=ww.0+1        /* add it to the list     */
    ww.z=l
    ww.0=z
    End
  End
Say cnt.3 'three letter words'
Say cnt.4 'four letter words'
Say cnt.5 'five letter words'
Say cnt.6 'six letter words'
Say cnt.7 'seven letter words'
Say cnt.8 'eight letter words'
n=0
Do i=1 To ww.0
  Parse Value split(ww.i) With u v
  If w.u & w.v Then Do
    n=n+1
    Say format(n,2) left(ww.i,8) left(u,4) v
    End
  End
Exit
split: Procedure
/* split the word into components */
  Parse Arg w
  s.=''
  Do While w<>''
    Parse Var w uu +1 vv +1 w
    s.u=s.u||uu
    s.v=s.v||vv
    End
  Return s.u s.v
