const unixwords = split(read("unixdict.txt", String) |> lowercase, r"\s+")

function findphrases(anastring::AbstractString, choices, sizelong = 4, n_shortpermitted = 1)
    anadict = Dict{Char, Int}()
    for c in lowercase(anastring)
        if 'a' <= c <= 'z'
            anadict[c] = get(anadict, c, 0) + 1
        end
    end
    phrases = String[]
    function addword(remaining, phrase, numshort)
        for w in unixwords
            len = length(w)
            numshort < 1 && len < sizelong && continue
            any(c -> get(remaining, c, 0) < count(==(c), w), w) && @goto nextword
            cdict = copy(remaining)
            for c in w
                cdict[c] -= 1
            end
            if all(==(0), values(cdict))
                return strip(phrase * " " * w)
            elseif (newphrase = addword(cdict, phrase * " " * w, numshort - (len < sizelong))) != nothing
                push!(phrases, newphrase)
                print(length(phrases), "\b\b\b\b\b\b\b\b\b")
            end
            @label nextword
        end
        return nothing
    end
    addword(anadict, "", n_shortpermitted)
    return phrases
end

for s in ["Rosetta code", "Joe Biden", "wherrera"]
    println("\nFrom '$s':")
    foreach(println, findphrases(s, unixwords, 4, 0) |> unique |> sort!)
end
