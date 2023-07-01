/* REXX ---------------------------------------------------------------
* 09.02.2014 Walter Pachl
* 22.02.2014 WP fix 'accounting' problem (courtesy GS)
*--------------------------------------------------------------------*/
c.=1
Numeric Digits 100
limit=200
pl=''
mmm=0
Do p=3 To limit
  pm1=p-1
  c.p.1=1
  c.p.p=1
  Do j=2 To p-1
    jm1=j-1
    c.p.j=c.pm1.jm1+c.pm1.j
    mmm=max(mmm,c.p.j)
    End
  End
Say '(x-1)**0 = 1'
do i=2 To limit
  im1=i-1
  sign='+'
  ol='(x-1)^'im1 '='
  Do j=i to 2 by -1
    If j=2 Then
      term='x  '
    Else
      term='x^'||(j-1)
    If j=i Then
      ol=ol term
    Else
      ol=ol sign c.i.j'*'term
    sign=translate(sign,'+-','-+')
    End
  If i<10 then
    Say ol sign 1
  Do j=2 To i-1
    If c.i.j//(i-1)>0 Then
      Leave
    End
  If j>i-1 Then
    pl=pl (i-1)
  End
Say ' '
Say 'Primes:' subword(pl,2,27)
Say '       ' subword(pl,29)
Say 'Largest coefficient:' mmm
Say 'This has' length(mmm) 'digits'
