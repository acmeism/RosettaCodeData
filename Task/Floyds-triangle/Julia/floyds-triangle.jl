function floydtriangle(rows)
    r = collect(1:div(rows *(rows + 1), 2))
    for i in 1:rows
        for j in 1:i
            print(rpad(lpad(popfirst!(r), j > 8 ? 3 : 2), j > 8 ? 4 : 3))
        end
        println()
    end
end

floydtriangle(5); println(); floydtriangle(14)
