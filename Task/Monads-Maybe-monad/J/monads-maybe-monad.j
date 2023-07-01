NB. monad implementation:
unit=: <
bind=: (@>)( :: ])

NB. monad utility
safeVersion=: (<@) ( ::((<_.)"_))
safeCompose=:dyad define
  dyad def 'x`:6 bind y'/x,unit y
)

NB. unsafe functions (fail with infinite arguments)
subtractFromSelf=: -~
divideBySelf=: %~

NB. wrapped functions:
safeSubtractFromSelf=: subtractFromSelf safeVersion
safeDivideBySelf=: divideBySelf safeVersion

NB. task example:
     safeSubtractFromSelf bind safeDivideBySelf 1
┌─┐
│0│
└─┘
     safeSubtractFromSelf bind safeDivideBySelf _
┌──┐
│_.│
└──┘
