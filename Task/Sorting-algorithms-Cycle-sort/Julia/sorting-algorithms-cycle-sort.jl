function cyclesort!(v::Vector)
    writes = 0
    for (cyclestart, item) in enumerate(v)
        pos = cyclestart
        for item2 in v[cyclestart + 1:end]
            if item2 < item pos += 1 end
        end

        if pos == cyclestart continue end
        while item == v[pos]
            pos += 1
        end
        v[pos], item = item, v[pos]
        writes += 1

        while pos != cyclestart
            pos = cyclestart
            for item2 in v[cyclestart + 1:end]
                if item2 < item pos += 1 end
            end
            while item == v[pos]
                pos += 1
            end

            v[pos], item = item, v[pos]
            writes += 1
        end
    end
    return v
end

v = rand(-10:10, 10)
println("# unordered: $v\n -> ordered: ", cyclesort!(v))
