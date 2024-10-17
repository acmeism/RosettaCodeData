'`turn board open full'=. {.`}.`(0=[{board@])`(0-.@e.board)
'`cpu pos'=. (?@#{])@([:I.0=board)`(cpu`you@.(_1 1 i.turn))
you=. $:@echo@'no'^:(-.@e.i.@9)@:<:@".@(1!:1)@1@echo@'enter a move (1–9):'
move=. pos ($:@][echo@'no')`(-@turn@], turn@]`[`(board@])})@.open ]
outcome=. 'tie'"_`(' wins',~ {&'.XO'@-@turn)@.won
show=. [ ''echo@, '',~ (,' '&,)/"1@({&'.XO')@(3 3$board)
won=. [: +./ 3 = [: | +/"1@(],|:,(<@0 1|:]),:<@0 1|:|.)@(3 3$board)
ttt=: [: outcome [: [F.(show@move[_2:Z:won+.full) 10&{.@_1
