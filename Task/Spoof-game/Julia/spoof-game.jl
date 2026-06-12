function queryint(prompt)
    while true
        print("\n", prompt, " (supply an integer) => ")
        (n = tryparse(Int, strip(readline(stdin)))) != nothing && return n
    end
end

function spoofgamefortwo()
    spoof = 0:6
    mypot, myguess, yourpot, yourguess = 0, 0, 0, 0
    ngames = queryint("How many games do you want?")
    for _ in 1:ngames
        while true
            mypot = rand(1:3)
            myguess = rand(1:6)
            if mypot + 3 < myguess
                break
            end
        end
        println("I have put my pot and guess.")
        while true
            yourpot = queryint("Your pot?")
            yourguess = queryint("Your guess?")
            if 0 <= yourpot <= 6 && 0 <= yourguess <= 6 && (yourpot + 4 > yourguess)
                break
            end
        end
        println("My put is: $mypot")
        println("My guess is: $myguess")
        pot = mypot + yourpot
        if myguess == pot && yourguess == pot
            println("Draw!")
        elseif myguess == pot
            println("I won!")
        elseif yourguess == pot
            println("You won!")
        else
            println("No winner!")
        end
    end
end

spoofgamefortwo()
