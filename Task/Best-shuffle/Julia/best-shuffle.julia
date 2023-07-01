# v0.6

function bestshuffle(str::String)::Tuple{String,Int}
    s = Vector{Char}(str)

    # Count the supply of characters.
    cnt = Dict{Char,Int}(c => 0 for c in s)
    for c in s; cnt[c] += 1 end

    # Allocate the result
    r = similar(s)
    for (i, x) in enumerate(s)
        # Find the best character to replace x.
        best = x
        rankb = -2
        for (c, rankc) in cnt
            # Prefer characters with more supply.
            # (Save characters with less supply.)
            # Avoid identical characters.
            if c == x; rankc = -1 end
            if rankc > rankb
                best = c
                rankb = rankc
            end
        end

        # Add character to list. Remove it from supply.
        r[i] = best
        cnt[best] -= 1
        if cnt[best] == 0; delete!(cnt, best) end
    end

    # If the final letter became stuck (as "ababcd" became "bacabd",
    # and the final "d" became stuck), then fix it.
    i = length(s)
    if r[i] == s[i]
        for j in 1:i
            if r[i] != s[j] && r[j] != s[i]
                r[i], r[j] = r[j], r[i]
                break
            end
        end
    end

    score = sum(x == y for (x, y) in zip(r, s))
    return r, score
end

for word in ("abracadabra", "seesaw", "elk", "grrrrrr", "up", "a")
    shuffled, score = bestshuffle(word)
    println("$word: $shuffled ($score)")
end
