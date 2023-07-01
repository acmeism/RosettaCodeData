"""
Two annotated example outputs
were given: 1) a run with three positive inputs, a zero, and
a negative number before the sentinel; 2) a run in which
the sentinel was the first and only input.
"""
function rainfall_problem(sentinel = 999999, allownegative = true)
    total, entries = 0, 0
    while true
        print("Enter rainfall as $(allownegative ? "" : "nonnegative ")integer ($sentinel to exit): ")
        n = tryparse(Int, readline())
        if n == sentinel
            break
        elseif n == nothing || !allownegative && n < 0
             println("Error: bad input. Try again\n")
        else
            total += n
            entries += 1
            println("Average rainfall is currently ", total / entries)
        end
    end
    if entries == 0
        println("No entries to calculate!")
    end
end

rainfall_problem()
