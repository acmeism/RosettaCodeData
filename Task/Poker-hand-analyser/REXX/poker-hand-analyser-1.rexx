/* REXX ---------------------------------------------------------------
* 10.12.2013 Walter Pachl
*--------------------------------------------------------------------*/

d.1='2h 2d 2s ks qd'; x.1='three-of-a-kind'
d.2='2h 5h 7d 8s 9d'; x.2='high-card'
d.3='ah 2d 3s 4s 5s'; x.3='straight'
d.4='2h 3h 2d 3s 3d'; x.4='full-house'
d.5='2h 7h 2d 3s 3d'; x.5='two-pair'
d.6='2h 7h 7d 7s 7c'; x.6='four-of-a-kind'
d.7='th jh qh kh ah'; x.7='straight-flush'
d.8='4h 4c kc 5d tc'; x.8='one-pair'
d.9='qc tc 7c 6c 4c'; x.9='flush'
d.10='ah 2h 3h 4h'
d.11='ah 2h 3h 4h 5h 6h'
d.12='2h 2h 3h 4h 5h'
d.13='xh 2h 3h 4h 5h'
d.14='2x 2h 3h 4h 5h'
Do ci=1 To 14
  Call poker d.ci,x.ci
  end
Exit

poker:
Parse Arg deck,expected
have.=0
f.=0; fmax=0
s.=0; smax=0
cnt.=0
If words(deck)<5 Then Return err('less than 5 cards')
If words(deck)>5 Then Return err('more than 5 cards')
Do i=1 To 5
  c=word(deck,i)
  Parse Var c f +1 s
  If have.f.s=1 Then Return err('duplicate card:' c)
  have.f.s=1
  m=pos(f,'a23456789tjqk')
  If m=0 Then Return err('invalid face' f 'in' c)
  cnt.m=cnt.m+1
  n=pos(s,'hdcs')
  If n=0 Then Return err('invalid suit' s 'in' c)
  f.m=f.m+1; fmax=max(fmax,f.m)
  s.n=s.n+1; smax=max(smax,s.n)
  End
cntl=''
cnt.14=cnt.1
Do i=1 To 14
  cntl=cntl||cnt.i
  End
Select
  When fmax=4 Then res='four-of-a-kind'
  When fmax=3 Then Do
    If x_pair() Then
      res='full-house'
    Else
      res='three-of-a-kind'
    End
  When fmax=2 Then Do
    If x_2pair() Then
      res='two-pair'
    Else
      res='one-pair'
    End
  When smax=5 Then Do
    If x_street() Then
      res='straight-flush'
    Else
      res='flush'
    End
  When x_street() Then
    res='straight'
  Otherwise
    res='high-card'
  End
Say deck res
If res<>expected Then
  Say copies(' ',14) expected
Return

x_pair:
  Do p=1 To 13
    If f.p=2 Then return 1
    End
  Return 0

x_2pair:
  pp=0
  Do p=1 To 13
    If f.p=2 Then pp=pp+1
    End
  Return pp=2

x_street:
  Return pos('11111',cntl)>0

err:
  Say deck 'Error:' arg(1)
  Return 0
