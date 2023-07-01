using Combinatorics

const tfile = download("http://wiki.puzzlers.org/pub/wordlists/unixdict.txt")
const wordlist = Dict(w => 1 for w in split(read(tfile, String), r"\s+"))

function wordwheel(wheel, central)
    returnlist = String[]
    for combo in combinations([string(i) for i in wheel])
        if central in combo && length(combo) > 2
            for perm in permutations(combo)
                word = join(perm)
                if haskey(wordlist, word) && !(word in returnlist)
                    push!(returnlist, word)
                end
            end
        end
    end
    return returnlist
end

println(wordwheel("ndeokgelw", "k"))
