using Printf

function watercollected(towers::Vector{Int})
    high_lft = vcat(0, accumulate(max, towers[1:end-1]))
    high_rgt = vcat(reverse(accumulate(max, towers[end:-1:2])), 0)
    waterlvl = max.(min.(high_lft, high_rgt) .- towers, 0)
    return waterlvl
end

function towerprint(towers, levels)
    ctowers = copy(towers)
    clevels = copy(levels)
    hmax = maximum(towers)
    ntow = length(towers)
    for h in hmax:-1:1
        @printf("%2i |", h)
        for j in 1:ntow
            if ctowers[j] + clevels[j] ≥ h
                if clevels[j] > 0
                    cell = "≈≈"
                    clevels[j] -= 1
                else
                    cell = "NN"
                    ctowers[j] -= 1
                end
            else
                cell = "  "
            end
            print(cell)
        end
        println("|")
    end


    println("   " * join(lpad(t, 2) for t in levels) * ": Water lvl")
    println("   " * join(lpad(t, 2) for t in towers) * ": Tower lvl")
end

for towers in [[1, 5, 3, 7, 2], [5, 3, 7, 2, 6, 4, 5, 9, 1, 2],
    [2, 6, 3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1],
    [5, 5, 5, 5], [5, 6, 7, 8], [8, 7, 7, 6], [6, 7, 10, 7, 6]]
    towerprint(towers, watercollected(towers))
    println()
end
