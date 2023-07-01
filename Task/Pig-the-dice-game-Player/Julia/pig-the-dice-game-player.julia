mutable struct Player
    score::Int
    ante::Int
    wins::Int
    losses::Int
    strategy::Pair{String, Function}
end

randomchoicetostop(player, group) = rand(Bool)
variablerandtostop(player, group) = any(x -> x.score > player.score, group) ? rand() < 0.1 : rand(Bool)
overtwentystop(player, group) = player.ante > 20
over20unlesslosingstop(player, group) = player.ante > 20 && all(x -> x.score < 80, group)

const strategies = ("random choice to stop" => randomchoicetostop, "variable rand to stop" => variablerandtostop,
                  "roll to 20" => overtwentystop, "roll to 20 then if not losing stop" => over20unlesslosingstop)
const players = [Player(0, 0, 0, 0, s) for s in strategies]
const dice = collect(1:6)

function turn(player, verbose=false)
    playernum = findfirst(p -> p == player, players)
    scorewin() = for p in players if p == player p.wins += 1 else p.losses += 1 end; p.score = 0 end
    player.ante = 0
    while (r = rand(dice)) != 1
        player.ante += r
        verbose && println("Player $playernum rolls a $r.")
        if player.score + player.ante >= 100
            scorewin()
            verbose && println("Player $playernum wins.\n")
            return false
        elseif player.strategy[2](player, players)
            player.score += player.ante
            verbose && println("Player $playernum holds and has a new score of $(player.score).")
            return true
        end
    end
    verbose && println("Player $playernum rolls a 1, so turn is over.")
    true
end

function rungames(N)
    for i in 1:N
        verbose = (i == 3) ? true : false  # do verbose if it's game number 3
        curplayer = rand(collect(1:length(players)))
        while turn(players[curplayer], verbose)
            curplayer = curplayer >= length(players) ? 1 : curplayer + 1
        end
    end
    results = sort([(p.wins/(p.wins + p.losses), p.strategy[1]) for p in players], rev=true)
    println("             Strategy                % of wins (N = $N)")
    println("------------------------------------------------------------")
    for pair in results
        println(lpad(pair[2], 34), lpad(round(pair[1] * 100, digits=1), 18))
    end
end

rungames(1000000)
