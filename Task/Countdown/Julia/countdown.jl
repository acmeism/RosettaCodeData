using Combinatorics

const max_pick = 6
const fulllist = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 25, 50, 75, 100]
const oplist = [+, +, +, +, +, +,  -, -, -, -, -, -,  *, *, *, *, *, *, ÷, ÷, ÷, ÷, ÷, ÷]


function single_countdown_game(ilist, target)
    candidates = [(0, "")]
    for i in 1:max_pick, arr in permutations(ilist, i), ops in multiset_permutations(oplist, length(arr) - 1)
        candidate = arr[1]
        if !isempty(ops)
            for (j, op) in pairs(ops)
                ((op == ÷) && candidate % arr[j + 1] != 0) && @goto nextops
                candidate = op(candidate, arr[j + 1])
            end
        end
        if abs(candidate - target) <= abs(candidates[1][1] - target)
            if abs(candidate - target) < abs(candidates[1][1] - target)
                empty!(candidates)
            end
            sops = push!(map(string, ops), "")
            push!(candidates, (candidate, prod(" $(arr[i]); $(sops[i])" for i in eachindex(arr))))
        end
        @label nextops
    end
    return unique(candidates)
end

for (terms, target) in [([2, 3, 3, 6, 9, 50], 476), ([1, 4, 6, 7, 8, 9], 657), ([4, 7, 8, 9, 10, 10], 300)]
    sols = single_countdown_game(terms, target)
    println("$(length(sols)) solutions for terms $terms, target $target.")
    println("  Example: $(sols[1][2])= $(sols[1][1])\n")
end
