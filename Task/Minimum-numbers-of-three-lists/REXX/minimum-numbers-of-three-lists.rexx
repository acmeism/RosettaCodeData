/* REXX */
w= 5 45 23 21 67 43 22 78 46 38 9 98 12 98 53
Do i=1 To 3
  Do j=1 To 5
    Parse Var w l.i.j w
    End
  End
o=''
Do j=1 To 5
  o=o min(l.1.j,l.2.j,l.3.j)
  End
Say strip(o)
