'`c t b e x'=.(?@#{])@([:I.0=b)`{.`}.`echo`(1:Z:1:)          NB. cpu's move; turn; board; print; exit
'`wm tm'=. (''e@, {&'.XO'@-@t ,' wins'"_)`([:e LF&,@'tie')   NB. print win/tie message
i=. (0=]{b@[) ::0 -.@*. ]e.i.@9                              NB. invalid posn? (x: state; y: posn)
y=. ($:@[ e@'no')^:i  _1+0".@(1!:1@1)@e@'move (1-9):'        NB. your move
m=. -@t , c`y@.(1=t) t@]`[`(b@])} ]                          NB. apply current player's move to board
d=. ''e@, '',~ (,' '&,)/"1@({&'.XO')@(3 3$b)                 NB. display the board
w=. 3 +./@:= |@(+/"1)@(],|:,(<@0 1|:|.),:<@0 1|:])@(3 3$b)   NB. test whether game has been won
g=: [: d F.(([ [x@tm^:(0-.@e.b) [x@wm^:w)@m) 10{._1:         NB. the game
