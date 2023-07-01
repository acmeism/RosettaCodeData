/* REXX */
Numeric Digits 16
Parse Arg s
If s='' Then
  s="1223334444"
occ.=0
chars=''
n=0
cn=0
Do i=1 To length(s)
  c=substr(s,i,1)
  If pos(c,chars)=0 Then Do
    cn=cn+1
    chars=chars||c
    End
  occ.c=occ.c+1
  n=n+1
  End
do ci=1 To cn
  c=substr(chars,ci,1)
  p.c=occ.c/n
  /* say c p.c */
  End
e=0
Do ci=1 To cn
  c=substr(chars,ci,1)
  e=e+p.c*rxcalclog(p.c)/rxcalclog(2)
  End
Say s 'Entropy' format(-e,,12)
Exit

::requires 'rxmath' LIBRARY
