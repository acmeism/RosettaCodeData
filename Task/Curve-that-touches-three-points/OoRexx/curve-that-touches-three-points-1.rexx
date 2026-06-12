/* REXX ***************************************************************
* Compute the polynome satisfying  three given Points
**********************************************************************/
pl='(10,10) (100,200) (200,10)'
Do i=1 To 3
  Parse Var pl '(' x.i ',' y.i ')' pl
  s.i=x.i**2 x.i 1 y.i
  End
Parse Value lingl() With a b c
If a<>0 Then
  gl=a'*x**2'
Else
  gl=''
If b>0 & gl<>'' Then b='+'||b
If b<>0 Then gl=gl||b'*x'
If c>0 & gl<>'' Then c='+'||c
If c<>0 Then gl=gl||c
Say 'y='gl
Say 'x / f(x) / y'
Do i=1 To 3
  Say x.i '/' fun(x.i) '/' y.i
  End
Exit

fun:
Parse Arg x
Return a*x**2+b*x+c

lingl: Procedure  Expose s.
/************************************************* Version: 25.11.1996 *
* Lösung eines linearen Gleichungssystems
* 22.11.1996 PA neu
***********************************************************************/
Numeric Digits 12
 Do i=1 to 3
   l=s.i
   Do j=1 By 1 While l<>''
     Parse Var l a.1.i.j l
     End
   m=j-1
   End
 n=i-1
 Do i=1 To n
   s=''
   Do j=1 To m
     s=s format(a.1.i.j,6,2)
     End
   Call dbg s
   End
Do ie=1 To i-1
  u=ie
  v=ie+1
  Do kk=ie To n
    If a.u.kk.ie<>0 Then Leave
    End
  Select
    When kk=ie Then Nop
    When kk>n Then Call ex 'eine Katastrophe'
    Otherwise Do
      Do jj=1 To m
        temp=a.u.ie.jj
        a.u.ie.jj=a.u.kk.jj
        a.u.kk.jj=temp
        End
      Do ip=1 To n
        s=''
        Do jp=1 To m
          s=s format(a.u.ip.jp,12,2)
          End
        Call dbg s
        End
      End
    End

  Do i=1 To n
    Do j=1 To m
      If i<=ie Then
        a.v.i.j=a.u.i.j
      Else
        a.v.i.j=a.u.i.j*a.u.ie.ie-a.u.i.ie*a.u.ie.j
      End
    End

   Call dbg copies('-',70)
   Do i=1 To n
     Do j=1 To m
       If a.v.i.j<>0 Then Leave
       End
     Select
       When j=m Then Call ex 'Widersprü�chliches Gleichungssystem'
       When j>m Then Call ex 'Gleichungen sind linear abhängig'
       Otherwise Nop
       End
     End
   Do i=1 To n
     s=''
     Do j=1 To m
       s=s format(a.v.i.j,12,2)
       End
     Call dbg s
     End
   End
n1=n+1
Do i=n To 1 By -1
  i1=i+1
  x.i=a.v.i.n1/a.v.i.i
  sub=0
  Do j=i+1 To n
    sub=sub+a.v.i.j*x.j
    End
  x.i=x.i-sub/a.v.i.i
  End

 sol=''
 Do i=1 To n
   sol=sol x.i
   End
Return sol

ex:
  Say arg(1)
  Exit

dbg: Return
