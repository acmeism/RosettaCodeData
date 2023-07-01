delay=: 6!:3

task=: {{
  obj=. '' conew 'integra'
  F__obj=: 1 o. o.
  delay 2
  F__obj=: 0:
  delay 0.5
  s=. S__obj
  destroy__obj''
  s
}}

coclass'integra'
 reqthreads=: {{ 0&T.@''^:(0>.y-1 T.'')0 }}
 time=: 6!:1
 F=: 0:
 K=: S=: SHUTDOWN=: 0
 create=: {{
  reqthreads cores=. {.8 T. ''
  integrator t. '' T=: time''
 }}
 destroy=: {{ codestroy '' [ SHUTDOWN=: 1 }}
 integrator=: {{
  while. -.SHUTDOWN do.
   t=. time''
   k=. F t
   S=: S + (k+K)*t-T
   T=: t
   K=: k
  end.
 }}
