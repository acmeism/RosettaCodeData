function trytowin(n)
    if 21 - n < 4
        println("Computer chooses $(21 - n) and wins. GG!")
        exit(0)
    end
end

function choosewisely(n)
    trytowin(n)
    targets = [1, 5, 9, 13, 17, 21]
    pos = findfirst(x -> x > n, targets)
    bestmove = targets[pos] - n
    if bestmove > 3
        println("Looks like I could lose. Choosing a 1, total now $(n + 1).")
        return n + 1
    end
    println("On a roll, choosing a $bestmove, total now $(n + bestmove).")
    n + bestmove
end

function choosefoolishly(n)
    trytowin(n)
    move = rand([1, 2, 3])
    println("Here goes, choosing $move, total now $(n + move).")
    n + move
end

function choosesemiwisely(n)
    trytowin(n)
    if rand() > 0.75
        choosefoolishly(n)
    else
        choosewisely(n)
    end
end

prompt(s) = (println(s, ": => "); return readline())

function playermove(n)
    rang = (n > 19) ? "1 is all" : ((n > 18) ? "1 or 2" : "1, 2 or 3")
    choice = 0
    while true
        nstr = prompt("Your choice ($rang), 0 to exit")
        if nstr == "0"
            exit(0)
        elseif nstr == "1"
            return n + 1
        elseif nstr == "2" && n < 20
            return n + 2
        elseif nstr == "3" && n < 19
            return n + 3
        end
    end
end


function play21game()
    n = 0
    level = prompt("Level of play (1=dumb, 3=smart)")
    algo = choosewisely
    if level == "1"
        algo = choosefoolishly
    elseif level == "2"
        algo = choosesemiwisely
    elseif level != "3"
        println("Bad choice syntax--default to smart choice")
    end
    whofirst = prompt("Does computer go first? (y or n)")
    if whofirst[1] == 'y' || whofirst[1] == 'Y'
        n = algo(n)
    end
    while n < 21
        n = playermove(n)
        if n == 21
            println("Player wins! Game over, gg!")
            break
        end
        n = algo(n)
    end
end

play21game()
