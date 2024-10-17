function johnsontrotter(low, high)
    function permutelevel(vec)
        if length(vec) < 2
            return [vec]
        end
        sequences = []
        endint = vec[end]
        smallersequences = permutelevel(vec[1:end-1])
        leftward = true
        for seq in smallersequences
            for pos in (leftward ? (length(seq)+1:-1:1): (1:length(seq)+1))
                push!(sequences, insert!(copy(seq), pos, endint))
            end
            leftward = !leftward
        end
        sequences
    end
    permutelevel(collect(low:high))
end

for (i, sequence) in enumerate(johnsontrotter(1,4))
    println("""$sequence, $(i & 1 == 1 ? "+1" : "-1")""")
end
