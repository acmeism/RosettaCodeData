   '`turn board open full'=: {.`}.`(0=[{board@])`(0-.@e.board)
   '`cpu_move position'=: (?@#{])@([:I.0=board)`(cpu_move`you_move@.(_1 1 i.turn))
   you_move=: $:@echo@'invalid'^:(-.@e.i.@9)@:<:@".@{.@;:@(1!:1@1)
   move=: position (][echo@'already taken!')`(-@turn@] , turn@]`[`(board@])})@.open ]
   show=: [ [: echo@''@echo (,' '&,)/"1@({&'.XO')@(3 3$board) [ echo@''
   won=: [: +./ (3=[:|+/)"1@(], |:, (<@i.@#|:]),: <@i.@#|:|.)@(3 3$board)
   prompt=: echo@:>:@i.@3 3@echo@'enter a move (1–9) each turn; you''re X''s'
   outcome=: (echo@'tie')`(' wins'echo@,~{&'.XO'@-@turn)@.won
   ttt=: outcome@([F.(show@move[_2:Z:won+.full))@(10{._1)@prompt
