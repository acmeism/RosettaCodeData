/* REXX */
l.1=.array~of( 5, 45, 23, 21, 67)
l.2=.array~of(43, 22, 78, 46, 38)
l.3=.array~of( 9, 98, 12, 98, 53)
o=''
Do i=1 To 5
  o=o min(l.1[i],l.2[i],l.3[i])
  End
Say strip(o)
