b::2 9#0                                                           / the board
WINMASKS::((9#2)\)'7 56 448 73 146 292 273 84                      / winning trios
fin:{`0:x," won";`exit 0}
{1}{({`1:"MOVE: ";$[(|/b)m:(`I$-1_1:`)-1;o`0:"NO";b[0;m]::1]}      / your move
     {b[1;(|/b)?0]::1})[x;0]                                       / cpu's move
    x{`0:" "/'`c$3 3#|/"XO*"*b,,~|/b}/0                            / show board after cpu moves
    $[+/3=0^WINMASKS(+/&)\:b x;fin "XO*" x;511=2/|/b;fin"the cat"] / test win
    ~x}/1                                                          / now it's other player's turn
