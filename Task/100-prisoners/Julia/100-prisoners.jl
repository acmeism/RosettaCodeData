using Random, Formatting

function randomplay(n, numprisoners=100)
    pardoned, indrawer, found = 0, collect(1:numprisoners), false
    for i in 1:n
        shuffle!(indrawer)
        for prisoner in 1:numprisoners
            found = false
            for reveal in randperm(numprisoners)[1:div(numprisoners, 2)]
                indrawer[reveal] == prisoner && (found = true) && break
            end
            !found && break
        end
        found && (pardoned += 1)
    end
    return 100.0 * pardoned / n
end

function optimalplay(n, numprisoners=100)
    pardoned, indrawer, found = 0, collect(1:numprisoners), false
    for i in 1:n
        shuffle!(indrawer)
        for prisoner in 1:numprisoners
            reveal = prisoner
            found = false
            for j in 1:div(numprisoners, 2)
                card = indrawer[reveal]
                card == prisoner && (found = true) && break
                reveal = card
            end
            !found && break
        end
        found && (pardoned += 1)
    end
    return 100.0 * pardoned / n
 end

const N = 100_000
println("Simulation count: $N")
println("Random play wins: ", format(randomplay(N), precision=8), "% of simulations.")
println("Optimal play wins: ", format(optimalplay(N), precision=8), "% of simulations.")
