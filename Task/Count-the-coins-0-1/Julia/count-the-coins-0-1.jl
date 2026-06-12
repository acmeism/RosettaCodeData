using Combinatorics

function coinsum(coins, targetsum; verbose=true)
    println("Coins are $coins, target sum is $targetsum:")
    combos, perms = 0, 0
    for choice in combinations(coins)
        if sum(choice) == targetsum
            combos += 1
            verbose && println("$choice sums to $targetsum")
            for perm in permutations(choice)
                verbose && println("    permutation: $perm")
                perms += 1
            end
        end
    end
    println("$combos combinations, $perms permutations.\n")
end

coinsum([1, 2, 3, 4, 5], 6)
coinsum([1, 1, 2, 3, 3, 4, 5], 6)
coinsum([1, 2, 3, 4, 5, 5, 5, 5, 15, 15, 10, 10, 10, 10, 25, 100], 40, verbose=false)
