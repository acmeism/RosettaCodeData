NB. game is solvable by optimal strategy when the length (#) of the
NB. longest (>./) cycle (C.) is at most 50.
opt=: 50 >: [: >./ [: > [: #&.> C.

NB. for each prisoner randomly open 50 boxes ((50?100){y) and see if
NB. the right card is there (p&e.). if not return 0.
rand=: monad define
for_p. i.100 do. if. -.p e.(50?100){y do. 0 return. end.
end. 1
)

NB. use both strategies on the same shuffles y times.
simulate=: monad define
'o r'=. y %~ 100 * +/ ((rand,opt)@?~)"0 y # 100
('strategy';'win rate'),('random';(":o),'%'),:'optimal';(":r),'%'
)
