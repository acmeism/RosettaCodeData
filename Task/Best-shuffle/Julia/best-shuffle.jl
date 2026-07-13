function bestshuffle(str::String)::Tuple{String,Int}
    s = collect(str)

    # Count the supply of characters.
    cnt = Dict{Char,Int}()
    for c in s
        cnt[c] = get(cnt, c, 0) + 1
    end

    # Allocate the result
    r = similar(s)
    for (i, x) in enumerate(s)
        # Pick the highest-frequency character that differs from x.
        # typemin ensures an identical character is never chosen over a different one.
        best = argmax(c -> c == x ? typemin(Int) : cnt[c], keys(cnt))
        r[i] = best
        cnt[best] -= 1
        iszero(cnt[best]) && delete!(cnt, best)
    end

    # If the final letter became stuck (as "ababcd" became "bacabd",
    # and the final "d" became stuck), then fix it.
    n = length(s)
    if r[n] == s[n]
        for j in 1:n-1   # j == n can never satisfy the condition, so skip it
            if r[n] != s[j] && r[j] != s[n]
                r[n], r[j] = r[j], r[n]
                break
            end
        end
    end

    score = count(splat(==), zip(r, s))
    return String(r), score
end

for word in ("abracadabra", "seesaw", "elk", "grrrrrr", "up", "a")
    shuffled, score = bestshuffle(word)
    println("$word: $shuffled ($score)")
end
