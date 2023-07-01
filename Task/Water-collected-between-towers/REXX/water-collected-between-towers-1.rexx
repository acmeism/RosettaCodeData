/* REXX */
Call bars '1 5 3 7 2'
Call bars '5 3 7 2 6 4 5 9 1 2'
Call bars '2 6 3 5 2 8 1 4 2 2 5 3 5 7 4 1'
Call bars '5 5 5 5'
Call bars '5 6 7 8'
Call bars '8 7 7 6'
Call bars '6 7 10 7 6'
Exit
bars:
Parse Arg bars
bar.0=words(bars)
high=0
box.=' '
Do i=1 To words(bars)
  bar.i=word(bars,i)
  high=max(high,bar.i)
  Do j=1 To bar.i
    box.i.j='x'
    End
  End
m=1
w=0
Do Forever
  Do i=m+1 To bar.0
    If bar.i>bar.m Then
      Leave
    End
  If i>bar.0 Then Leave
  n=i
  Do i=m+1 To n-1
    w=w+bar.m-bar.i
    Do j=bar.i+1 To bar.m
      box.i.j='*'
      End
    End
  m=n
  End
m=bar.0
Do Forever
  Do i=bar.0 To 1 By -1
    If bar.i>bar.m Then
      Leave
    End
  If i<1 Then Leave
  n=i
  Do i=m-1 To n+1 By -1
    w=w+bar.m-bar.i
    Do j=bar.i+1 To bar.m
      box.i.j='*'
      End
    End
  m=n
  End
Say bars '->' w
Call show
Return
show:
Do j=high To 1 By -1
  ol=''
  Do i=1 To bar.0
    ol=ol box.i.j
    End
  Say ol
  End
Return
