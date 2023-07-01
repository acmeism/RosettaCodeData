root=: %:
incr=: >:
half=: -:

tostr=: ,@":

loggingVersion=: conjunction define
  n;~u
)

Lroot=: root loggingVersion 'obtained square root'
Lincr=: incr loggingVersion 'added 1'
Lhalf=: half loggingVersion 'divided by 2'

loggingUnit=: verb define
  y;'Initial value: ',tostr y
)

loggingBind=: adverb define
  r=. u 0{::y
  v=. 0{:: r
  v;(1{::y),LF,(1{::r),' -> ',tostr v
)

loggingCompose=: dyad define
  ;(dyad def '<x`:6 loggingBind;y')/x,<loggingUnit y
)
