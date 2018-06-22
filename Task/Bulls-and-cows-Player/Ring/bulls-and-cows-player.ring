# Project : Bulls and cows/Player
# Date    : 2017/11/21
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

secret = ""
while len(secret) != 4
        c = char(48 + random(9))
        if substr(secret, c) = 0
           secret = secret + c
        ok
end
see "secret = " + secret + nl

possible = ""
for i = 1234 to 9876
     possible = possible + string(i)
next

see "guess a four-digit number with no digit used twice." + nl
guesses = 0
while true
        bulls = 0
        cows = 0
        if len(possible) = 4
           guess = possible
        else
           guess = substr(possible, 4*random(len(possible) / 4) - 3, 4)
        ok
        see "computer guesses " + guess + nl
        guesses = guesses + 1
        if guess = secret
           see "correctly guessed after " + guesses + " guesses!" + nl
           exit
        ok
        if len(guess) = 4
           count(secret, guess, bulls, cows)
        ok
        i = 1
        testbulls = 0
        testcows = 0
        while  i <= len(possible)
                 temp = substr(possible, i, 4)
                 if len(guess) = 4
                    count(temp, guess, testbulls, testcows)
                 ok
                 if bulls=testbulls
                    if cows=testcows
                       i = i + 4
                    ok
                 else
                    possible = left(possible, i-1) + substr(possible, i+4)
                 ok
        end
        if substr(possible, secret) = 0
           exit
        ok
end

func count(secret, guess, bulls,  cows)
       bulls = 0
       cows = 0
       for nr = 1 to 4
            c = secret[nr]
            if guess != 0
               if guess[nr] = c
                  bulls = bulls + 1
                  if substr(guess, c) > 0
                     cows = cows + 1
                  ok
               ok
            ok
       next
       see "giving " + bulls + " bull(s) and " + cows  + " cow(s)." + nl
       return [bulls, cows]
