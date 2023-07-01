mopk=: 4 : 0
 a=. x: x
 'p k'=. x: y
 pm=. (p^k)&|@^
 t=. (p-1)*p^k-1  NB. totient
 'q e'=. __ q: t
 x=. a pm t%q^e
 d=. (1<x)+x (pm i. 1:)&> (e-1) */\@$&.> q
 */q^d
)
