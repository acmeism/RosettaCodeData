const seen = Dict{Vector{Char}, Vector{Char}}()

function findnextterm(prevterm)
    counts = Dict{Char, Int}()
    reversed = Vector{Char}()
    for c in prevterm
        if !haskey(counts, c)
            counts[c] = 0
        end
        counts[c] += 1
    end
    for c in sort(collect(keys(counts)))
        if counts[c] > 0
            push!(reversed, c)
            if counts[c] == 10
                push!(reversed, '0'); push!(reversed, '1')
            else
                push!(reversed, Char(UInt8(counts[c]) + UInt8('0')))
            end
        end
    end
    reverse(reversed)
end

function findsequence(seedterm)
    term = seedterm
    sequence = Vector{Vector{Char}}()
    while !(term in sequence)
        push!(sequence, term)
        if !haskey(seen, term)
            nextterm = findnextterm(term)
            seen[term] = nextterm
        end
        term = seen[term]
    end
    return sequence
end

function selfseq(maxseed)
    maxseqlen = -1
    maxsequences = Vector{Pair{Int, Vector{Char}}}()
    for i in 1:maxseed
        seq = findsequence([s[1] for s in split(string(i), "")])
        seqlen = length(seq)
        if seqlen > maxseqlen
            maxsequences = [Pair(i, seq)]
            maxseqlen = seqlen
        elseif seqlen == maxseqlen
            push!(maxsequences, Pair(i, seq))
        end
    end
    println("The longest sequence length is $maxseqlen.")
    for p in maxsequences
        println("\n Seed: $(p[1])")
        for seq in p[2]
            println("     ", join(seq, ""))
        end
    end
end

selfseq(1000000)
