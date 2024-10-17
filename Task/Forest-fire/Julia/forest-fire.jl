using Printf

@enum State empty tree fire


function evolution(nepoch::Int=100, init::Matrix{State}=fill(tree, 30, 50))
    # Single evolution
    function evolve!(forest::Matrix{State}; f::Float64=0.12, p::Float64=0.5)
        dir = [-1 -1; -1 0; -1 1; 0 -1; 0 1; 1 -1; 1 0; 1 1]
        # A tree will burn if at least one neighbor is burning
        for i in 1:size(forest, 1), j in 1:size(forest, 2)
            for k in 1:size(dir, 1)
                if checkbounds(Bool, forest, i + dir[k, 1], j + dir[k, 2]) &&
                    get(forest, i + dir[k, 1], j + dir[k, 2]) == fire
                    forest[i, j] = fire
                    break
                end
            end
        end
        for i in LinearIndices(forest)
            # A burning cell turns into an empty cell
            if forest[i] == fire forest[i] = empty end
            # A tree ignites with probability f even if no neighbor is burning
            if forest[i] == tree && rand() < f forest[i] = fire end
            # An empty space fills with a tree with probability p
            if forest[i] == empty && rand() < p forest[i] = tree end
        end
    end

    # Print functions
    function printforest(f::Matrix{State})
        for i in 1:size(f, 1)
            for j in 1:size(f, 2)
                print(f[i, j] == empty ? ' ' : f[i, j] == tree ? '🌲' : '🔥')
            end
            println()
        end
    end
    function printstats(f::Matrix{State})
        tot = length(f)
        nt  = count(x -> x in (tree, fire), f)
        nb  = count(x -> x == fire, f)
        @printf("\n%6i cell(s), %6i tree(s), %6i currently burning (%6.2f%%, %6.2f%%)\n",
                tot, nt, nb, nt / tot * 100, nb / nt * 100)
    end

    # Main
    printforest(init)
    printstats(init)
    for i in 1:nepoch
        # println("\33[2J")
        evolve!(init)
        # printforest(init)
        # printstats(init)
        # sleep(1)
    end
    printforest(init)
    printstats(init)
end

evolution()
