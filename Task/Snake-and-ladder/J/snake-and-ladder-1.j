require 'format/printf general/misc/prompt'
SnakesLadders=:  _2 ]\ 4 14 9 31 17 7 20 38 28 84 40 59 51 67 54 34 62 19 63 81 64 60 71 91 87 24 93 73 95 75 99 78
'idx val'=:  |: SnakesLadders
Board=: val idx} i. >: 100               NB. representation of the board

rollDice=: 1 + $ ?@$ 6:                  NB. roll dice once for each player
playTurn=: Board {~ 100 <. rollDice + ]  NB. returns list of new posisitions given a list of starting positions

NB. Given the number of players, runs until one player reaches 100
runGame=: [: playTurn^:(100 -.@e. ])^:(<_) $&0

NB. Report player positions after each turn and result
report=: ('Player %d won!' sprintf 100 >:@i.~ {:) , echo

start=: >:@".@prompt&'How many players to play against?' [ echo bind 'You are Player 1!'
playSnakesLadders=: [: report@runGame start
