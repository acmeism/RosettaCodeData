output=. ['Bulls: '&,:@'Cows: 'echo@,.":@,.
valid =. *./@e.&Num_j_*.4=#
guess =. 0 ".&> [: > $:^:(-.@valid)@(1!:1@1)@echo@'Guess:'t.0
game  =. [ $:^:(4 0-.@-:]) [ (+/@:= output@, e. +/@:*. ~:) guess
moo   =. 'You win!'[ (1+4?9:) game ]
