# Project : Bulls and cows
# Date    : 2017/11/19
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

secret = ""
while len(secret) != 4
        c = char(48 + random(9))
        if substr(secret, c) = 0
           secret = secret + c
        ok
end

see "guess a four-digit number with no digit used twice."
guesses = 0
guess = ""
while true
        guess = ""
        while len(guess) != 4
                see "enter your guess: "
                give guess
                if len(guess) != 4
                   see "must be a four-digit number" + nl
                ok
        end
        guesses = guesses + 1
        if guess = secret
           see "you won after " + guesses + " guesses!"
           exit
        ok
        bulls = 0
        cows = 0
        for i = 1 to 4
             c = secret[i]
             if guess[i] = c
                bulls = bulls + 1
             but substr(guess, c) > 0
                 cows = cows + 1
             ok
        next
        see "you got " + bulls + " bull(s) and " + cows + " cow(s)." + nl
end
