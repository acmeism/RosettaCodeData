# Project : Rock-paper-scissors
# Date    : 2018/03/25
# Author : Gal Zsolt [~ CalmoSoft ~]
# Email   : <calmosoft@gmail.com>

see "
welcome to the game of rock-paper-scissors.
each player guesses one of these three, and reveals it at the same time.
rock blunts scissors, which cut paper, which wraps stone.
if both players choose the same, it is a draw!
when you've had enough, choose q.
"
g = ["rock","paper","scissors"]
total=0 draw=0
pwin=0 cwin=0
see "what is your move (press r, p, or s)?"
while true
        c=random(2)+1
        give q
        gs = floor((substr("rpsq",lower(q))))
        if gs>3 or gs<1
           summarise()
           exit
        ok
        total = total + 1
        see"you chose " + g[gs] + " and i chose " + g[c] + nl
        temp = gs-c
        if temp = 0
           see ". it's a draw"
           draw = draw + 1
        ok
        if temp = 1 or temp = -2
           see ". you win!"
           pwin = pwin + 1
        ok
        if temp = (-1) or temp = 2
            see ". i win!"
            cwin = cwin + 1
        ok
end
