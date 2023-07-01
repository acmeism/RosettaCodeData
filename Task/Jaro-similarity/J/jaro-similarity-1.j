jaro=: dyad define
  d=. ((x >.&# y)%2)-1
  e=. (x =/y) * d >: |x -/&(i.@#) y
  xm=. (+./"1 e)#x
  ym=. (+./"2 e)#y
  m=. xm <.&# ym
  t=. (+/xm ~:&(m&{.) ym)%2
  s1=. #x
  s2=. #y
  ((m%s1)+(m%s2)+(m-t)%m)%3
)
