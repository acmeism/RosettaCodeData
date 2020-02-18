function floydtriangle(rows)
    r = collect(1:div(rows *(rows + 1), 2))
    spacing = Int(ceil(log10(r[end] + 1))) + 1
    for i in 1:rows
        for _ in 1:i
            print(lpad(popfirst!(r), spacing))
        end
        println()
    end
end

floydtriangle(5); println(); floydtriangle(14)
