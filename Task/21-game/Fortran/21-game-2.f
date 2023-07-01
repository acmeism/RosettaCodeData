#define PLAYER 1
#define COMP   0
randomize timer

dim as uinteger sum, add = 0
dim as uinteger turn = int(rnd+0.5)
dim as uinteger precomp(0 to 3) = { 1, 1, 3, 2 }

while sum < 21:
    turn = 1 - turn
    print using "The sum is ##"; sum
    if turn = PLAYER then
        print "It is your turn."
        while add < 1 orelse add > 3 orelse add+sum > 21
            input "How many would you like to add? ", add
        wend
    else
        print "It is the computer's turn."
        add = precomp(sum mod 4)
        print using "The computer adds #."; add
    end if
    print
    sum = sum + add
    add = 0
wend

if turn = PLAYER then
    print "Congratulations. You win."
else
    print "Bad luck. The computer wins."
end if
