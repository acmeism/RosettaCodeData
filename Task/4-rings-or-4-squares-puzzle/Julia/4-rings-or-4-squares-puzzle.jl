using Combinatorics

function foursquares(low, high, onlyunique=true, showsolutions=true)
    integers = collect(low:high)
    count = 0
    sumsallequal(c) = c[1] + c[2] == c[2] + c[3] + c[4] == c[4] + c[5] + c[6] == c[6] + c[7]
    combos = onlyunique ? combinations(integers) :
                          with_replacement_combinations(integers, 7)
    for combo in combos, plist in unique(collect(permutations(combo, 7)))
        if sumsallequal(plist)
            count += 1
            if showsolutions
                println("$plist is a solution for the list $integers")
            end
        end
    end
    println("""Total $(onlyunique?"unique ":"")solutions for HIGH $high, LOW $low: $count""")
end

foursquares(1, 7, true, true)
foursquares(3, 9, true, true)
foursquares(0, 9, false, false)
