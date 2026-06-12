const landingtoending = Dict(4 => 14, 9 => 31, 17 => 7, 20 => 38, 28 => 84, 40 => 59,
    51 => 67, 54 => 34, 62 => 19, 63 => 81, 64 => 60, 71 => 91, 87 => 24, 93 => 73,
    95 => 75, 99 => 78)

const sixesrollagain = true

function takeaturn(player, square, verbose=true)
    while true
        roll = rand(1:6)
        verbose && print("Player $player on square $square rolls a $roll ")
        if square + roll > 100
            verbose && println(" but cannot move.")
        else
            square += roll
            verbose && println(" and moves to square $square.")
            if square == 100
                return 100
            end
            next = get(landingtoending, square, square)
            if square < next
                verbose && println("Yay! landed on a ladder. Climb up to $next.")
                if square == 100
                    return 100
                end
                square = next
            elseif square > next
                verbose && println("Oops! Landed on a snake chute. Slither down to $next.")
                square = next
            end
        end
        if roll < 6 || !sixesrollagain
            return square
        else
            verbose && println("Rolled a 6, so roll again.")
        end
    end
end

function snakesandladdersgame(nplayers, verbose=true)
    players = ones(Int, nplayers)
    while true
        for (player, position) in enumerate(players)
            ns = takeaturn(player, position, verbose)
            if ns == 100
                verbose && println("Player $player wins!")
                return player
            end
            players[player] = ns
            verbose && println()
        end
    end
end

snakesandladdersgame(3)

using DataFrames, GLM

function slstats(nplayers, ngames)
    players = zeros(Int, nplayers)
    for i in 1:ngames
        winner = snakesandladdersgame(nplayers, false)
        players[winner] += 1
    end
    println("\n\n\nStats: out of $ngames games, winners by order of play are:\n    #  |  wins \n----------------")
    for (i, player) in enumerate(players)
        println("    $i   $player")
    end
    data = DataFrame(X = collect(1:nplayers), Y = players)
    ols = lm(@formula(Y ~ X), data)
    println("\nStatistics:\n", ols)
end

slstats(5, 1000000)
