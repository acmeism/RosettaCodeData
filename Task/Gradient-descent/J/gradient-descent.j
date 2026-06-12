load 'math/calculus'
coinsert 'jcalculus'

NB. initial guess

go=: 0.1 _1

NB. function

func=: monad define
'xp yp' =. y
((1-xp)*(1-xp) * ]  ^-(yp)^2) + yp*(yp+2)* ] ^ _2 * xp^2   NB. evaluates from right to left without precedence
)

NB. gradient descent

shortygd =: monad define
go=.y
go=. go - 0.03 * func pderiv 1 ] go   NB. use D. instead of pderiv for earlier versions
)

NB. use:

shortygd ^:_ go

