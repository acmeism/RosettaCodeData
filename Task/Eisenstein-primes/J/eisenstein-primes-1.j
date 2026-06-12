eisensteinprimes=: {{
  rY=. >.1.5%:y
  p1=. ,(w^i.3)*/(#~ 2= 3|]) p:i.rY
  'a b'=. |:(2#rY)#:I.,1 p: {{(x*x)+(y*y)-x*y}}"0/~i.rY
  y{.(/: *:@|)p1,(,-)(a+b*w),a+b*-w
}}
