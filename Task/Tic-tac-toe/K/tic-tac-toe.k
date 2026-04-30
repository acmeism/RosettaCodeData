b::2 9#0; WINMASKS::((9#2)\)'7 56 448 73 146 292 273 84            / the board and winning trios
{1}{({`1:"MOVE: ";$[(|/b)m:(`I$-1_1:`)-1;o`0:"NO";b[0;m]::1]}      / your move
     {b[1;*1?&~|/b]::1})[x;]                                       / cpu's move
    x{`0:" "/'`c$3 3#|/"XO*"*b,,~|/b}/0                            / show board after each move
    w:|/3=0^WINMASKS(+/&)\:b x;f:511=2/|/b                         / test win and full conditions
    $[w|f;[`0:("the cat";"XO"x)[w]," won";`exit 0];]               / when game is over, exit and print winner
    ~x}/1                                                          / now it's other player's turn
