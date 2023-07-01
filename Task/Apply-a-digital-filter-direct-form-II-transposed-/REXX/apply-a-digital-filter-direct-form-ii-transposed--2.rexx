/* REXX */
Numeric Digits 24
acoef = '1.00000000, -2.77555756e-16, 3.33333333e-01, -1.85037171e-17'
bcoef = '0.16666667, 0.5, 0.5, 0.16666667'
signal = '-0.917843918645, 0.141984778794, 1.20536903482, 0.190286794412,',
         '-0.662370894973, -1.00700480494, -0.404707073677 ,0.800482325044,',
         ' 0.743500089861, 1.01090520172, 0.741527555207, 0.277841675195,',
         ' 0.400833448236, -0.2085993586, -0.172842103641, -0.134316096293,',
         ' 0.0259303398477, 0.490105989562, 0.549391221511, 0.9047198589'

Do i=1 By 1 While acoef>'';  Parse Var acoef a.i . ',' acoef;   End; a.0=i-1
Do i=1 By 1 While bcoef>'';  Parse Var bcoef b.i . ',' bcoef;   End; b.0=i-1
Do i=1 By 1 While signal>''; Parse Var signal s.i . ',' signal; End; s.0=i-1

ret.=0
Do i=1 To s.0
  temp=0.0
  Do j=1 To b.0
    if i-j>=0 Then Do
      u=i-j+1
      temp=temp+b.j*s.u
      End
    End
  Do j=1 To a.0
    if i-j>=0 Then Do
      u=i-j+1
      temp=temp-a.j*ret.u
      End
    End
  ret.i=temp/a.1
  Say format(i,2) format(ret.i,2,12)
  End
