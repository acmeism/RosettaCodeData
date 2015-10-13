type PigPlayer
    name::String
    score::Int
    strat::Function
end

function PigPlayer(a::String)
    PigPlayer(a, 0, pig_manual)
end

function scoreboard(pps::Array{PigPlayer,1})
    join(map(x->@sprintf("%s has %d", x.name, x.score), pps), " | ")
end

function pig_manual(pps::Array{PigPlayer,1}, pdex::Integer, pot::Integer)
    pname = pps[pdex].name
    print(pname, " there is ", @sprintf("%3d", pot), " in the pot.  ")
    print("<ret> to continue rolling? ")
    return chomp(readline()) == ""
end

function pig_round(pps::Array{PigPlayer,1}, pdex::Integer)
    pot = 0
    rcnt = 0
    while pps[pdex].strat(pps, pdex, pot)
        rcnt += 1
        roll = rand(1:6)
        if roll == 1
            return (0, rcnt, false)
        else
            pot += roll
        end
    end
    return (pot, rcnt, true)
end

function pig_game(pps::Array{PigPlayer,1}, winscore::Integer=100)
    pnum = length(pps)
    pdex = pnum
    println("Playing a game of Pig the Dice.")
    while(pps[pdex].score < winscore)
        pdex = rem1(pdex+1, pnum)
        println(scoreboard(pps))
        println(pps[pdex].name, " is now playing.")
        (pot, rcnt, ispotwon) = pig_round(pps, pdex)
        print(pps[pdex].name, " played ", rcnt, " rolls ")
        if ispotwon
            println("and scored ", pot, " points.")
            pps[pdex].score += pot
        else
            println("and butsted.")
        end
    end
    println(pps[pdex].name, " won, scoring ", pps[pdex].score, " points.")
end

pig_game([PigPlayer("Alice"), PigPlayer("Bob")])
