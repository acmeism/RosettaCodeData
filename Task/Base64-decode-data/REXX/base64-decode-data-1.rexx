z= 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
do i=1 to 64
  bs.i=x2b(d2x(i-1))
  c=substr(z,i,1)
  ds.c=right(bs.i,6,0)
  End
e='YW55IGNhcm5hbCBwbGVhc3VyZS4'
r=''
ec=e
Do While ec<>''
  Parse Var ec c +1 ec
  r=r||ds.c
  End
res=''
Do while r<>''
  Parse Var r x +8 r
  res=res||x2c(b2x(x))
  End
Say 'Input:   >'e'<'
Say 'decoded: >'res'<'
