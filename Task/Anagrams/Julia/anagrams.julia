url = "http://wiki.puzzlers.org/pub/wordlists/unixdict.txt"
wordlist = open(readlines, download(url))

wsort(word::AbstractString) = join(sort(collect(word)))

function anagram(wordlist::Vector{<:AbstractString})
    dict = Dict{String, Set{String}}()
    for word in wordlist
        sorted = wsort(word)
        push!(get!(dict, sorted, Set{String}()), word)
    end
    wcnt = maximum(length, values(dict))
    return collect(Iterators.filter((y) -> length(y) == wcnt, values(dict)))
end

println.(anagram(wordlist))
