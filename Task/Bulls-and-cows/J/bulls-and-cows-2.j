U       =. {{u^:(-.@:v)^:_.}}   NB. apply u until v is true
input   =. 1!:1@1@echo@'Guess: '
output  =. [ ('Bulls: ',:'Cows: ')echo@,.":@,.
isdigits=. *./@e.&'0123456789'
valid   =. isdigits*.4=#
guess   =. [:".&>input U(valid@])
bulls   =. +/@:=
cows    =. [:+/e.*.~:
game    =. ([:output [(bulls,cows) guess)U(4 0-:])
random  =. 1+4?9:
moo     =. 'You win!'[ random game ]
