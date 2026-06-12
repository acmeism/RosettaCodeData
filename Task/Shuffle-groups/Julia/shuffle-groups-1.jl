using Combinatorics

shufflegroups(number::Integer) = [evalpoly(10, a) for a in permutations(digits(number))]

function testshufflegroups()
    i = 11
    count = 0
    breakdown = Dict{Int, Int}()

    println("First 20 shuffle groups:\n")
    println(" Index  Number  Witness\n", '-'^24)

    for i in 1:typemax(Int32)
        i > 9 && i % 10 == 0 && continue
        witness = unique!([group ÷ i for group in shufflegroups(i) if group > i && group % i == 0])
        witnesscount = length(witness)
        witnesscount < 1 && continue
        breakdown[witnesscount] = get(breakdown, witnesscount, 0) + 1
        count += 1
        count <= 20 && print(lpad(count, 4), lpad(i, 9), lpad(first(witness), 7), "\n")

        if length(witness) > 4
            witness_string = join(witness, ", ")
            pad = length(witness_string) + 4

            println("\nFirst shuffle group with more than 4 witnesses:\n")
            println(" Index   Number     Witness\n", '-'^30)
            println(lpad(count, 6), lpad(i, 9), lpad(rpad(witness_string, pad), pad + 2))
            println("\nFor the first $count shuffle groups, there are:")
            for (k, v) in breakdown
                println("$(lpad(v, 4)) with $k witness", k > 1 ? "es" : "")
            end
            break
        end
    end
end

@time testshufflegroups()
