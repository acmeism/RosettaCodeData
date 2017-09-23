/*REXX list (the longest) ordered word(s) from a supplied dictionary. */
iFID= 'UNIXDICT.TXT'
w.=''
mL=0
Do j=1 While lines(iFID)\==0
  x=linein(iFID)
  w=length(x)
  If w>=mL Then Do
    Parse Upper Var x xU 1 z 2
    Do k=2 To w
      _=substr(xU, k, 1)
      If \datatype(_, 'U')  Then Iterate
      If _<z                Then Iterate j
      z=_
      End
    mL=w
    w.w=w.w  x
    End
  End
nn=words(w.mL)
Say nn 'word's(nn) "found (of length" mL')'
Say ''
Do n=1 To nn
  Say word(w.mL, n)
  End
Exit
s: Return left('s',arg(1)>1)
