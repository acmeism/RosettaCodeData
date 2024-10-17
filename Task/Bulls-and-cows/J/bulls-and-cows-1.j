output=. [ 'Bulls: '&,:@'Cows: ' echo@,. ":@,.
valid =. *./@e.&'0123456789' *. 4 = #
guess =. [: ".&> :: ] $:^:(-.@valid)@(1!:1@1)@echo@'Guess:'
game  =. [ $:^:(4 0-.@-:]) [ (+/@:= output@, e.+/@:*.~:) guess
moo   =. 'You win!'[ (1+4?9:) game ]
