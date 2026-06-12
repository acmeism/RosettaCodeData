# Project : Spoof game

spoof = 0:6
see "How many games you want? "
give games

for n = 1 to games
     while true
             mypot = random(3)
             myguess = random(6)
             if mypot + 3 >= myguess
                loop
             else
                exit
             ok
     end
     see "I have put my pot and guess" + nl
     while true
             see "Your pot? "
             give yourpot
             see "Your guess? "
             give yourguess
             if ascii(yourpot) < 48 or ascii(yourpot) > 54 or ascii(yourguess) < 48 or ascii(yourguess) > 54
                loop
             ok
             if yourpot + 3 >= yourguess
                exit
             else
                see "Bad input! Try again" + nl
                loop
             ok
     end
     see "My put is: " + mypot + nl
     see "My guess is: " + myguess + nl
     pot = mypot + yourpot
     if myguess = pot and yourguess = pot
        see "Draw!" + nl
     elseif myguess = pot
        see "I won!" + nl
     elseif yourguess = pot
        see "You won!" + nl
     else
        see "No winner!" + nl
     ok
next
