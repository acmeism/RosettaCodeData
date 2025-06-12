'`c t b'=. (?@#{])@([:I.0=b)`{.`}.                            NB. cpu's move; extract turn/board
v=. (0=]{b@[) :: 0 *. ]e.i.@9                                 NB. posn (y) valid and open on board (x)?
y=. ($:@[ echo@'no')^:(-.@v) _1+0".1!:1@1@echo@'move (1-9):'  NB. your move
m=. (-,])@t [`(0,1+c`y@.(1=t)@])} ]                           NB. apply current player's move to board
o=. 'tie'"_`(' wins',~ {&'.XO'@-@t)@.w                        NB. print game outcome
d=. [ ''echo@, '',~ (,' '&,)/"1@({&'.XO')@(3 3$b)             NB. display the board
w=. [:+./ 3 = |@(+/"1)@(],|:,(<@0 1|:|.),:<@0 1|:])@(3 3$b)   NB. test whether game has been won
g=: [: o [: d@m^:(-.@w*.0 e.b)^:_. _1:,9#0:                   NB. game; move & display until won or full
