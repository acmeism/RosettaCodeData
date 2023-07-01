/* REXX (required by some interpreters) */
Numeric Digits 1000000
ttest ='[(10, 13), (56, 101), (1030, 10009), (44402, 100049)]'
Do While pos('(',ttest)>0
  Parse Var ttest '(' n ',' p ')' ttest
  r = tonelli(n, p)
  Say "n =" n "p =" p
  Say "          roots :" r (p - r)
  End
Exit

legendre: Procedure
  Parse Arg a, p
  return pow(a, (p - 1) % 2, p)

tonelli: Procedure
  Parse Arg n, p
  q = p - 1
  s = 0
  Do while q // 2 == 0
    q = q % 2
    s = s+1
    End
  if s == 1 Then
    return pow(n, (p + 1) % 4, p)
  Do z=2 To p
    if p - 1 == legendre(z, p) Then
      Leave
    End
  c = pow(z, q, p)
  r = pow(n, (q + 1) / 2, p)
  t = pow(n, q, p)
  m = s
  t2 = 0
  Do while (t - 1) // p <> 0
    t2 = (t * t) // p
    Do i=1 To m
      if (t2 - 1) // p == 0 Then
        Leave
      t2 = (t2 * t2) // p
      End
    y=2**(m - i - 1)
    b = pow(c, y, p)
    If b=10008 Then Trace ?R
    r = (r * b) // p
    c = (b * b) // p
    t = (t * c) // p
    m = i
    End
  return r
pow: Procedure
  Parse Arg x,y,z
  If y>0 Then
    p=x**y
  Else p=x
  If z>'' Then
    p=p//z
  Return p
