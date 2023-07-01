normalize(s) = sort([sort(bounds) for bounds in s])

function consolidate(ranges)
    norm = normalize(ranges)
    for (i, r1) in enumerate(norm)
        if !isempty(r1)
            for r2 in norm[i+1:end]
                if !isempty(r2) && r1[end] >= r2[1]     # intersect?
                    r1 .= [r1[1], max(r1[end], r2[end])]
                    empty!(r2)
                end
            end
        end
    end
    [r for r in norm if !isempty(r)]
end

function testranges()
    for s in [[[1.1, 2.2]], [[6.1, 7.2], [7.2, 8.3]], [[4, 3], [2, 1]],
              [[4, 3], [2, 1], [-1, -2], [3.9, 10]],
              [[1, 3], [-6, -1], [-4, -5], [8, 2], [-6, -6]]]
        println("$s => $(consolidate(s))")
    end
end

testranges()
