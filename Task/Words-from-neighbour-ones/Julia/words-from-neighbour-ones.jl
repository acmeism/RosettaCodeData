function wordsfromneighbourones(wordfile::String, len = 9, colwidth = 11, numcols = 8)
    println("Word source: $wordfile\n")
    words = filter(w -> length(w) >= len, split(read(wordfile, String), r"\s+"))
    dict, shown, found = Dict(w => 1 for w in words), 0, String[]
    for position in eachindex(@view words[1:end-len+1])
        new_word = prod([words[i + position - 1][i] for i in 1:len])
        if haskey(dict, new_word) && !(new_word in found)
            push!(found, new_word)
            print(rpad(new_word, colwidth), (shown += 1) % numcols == 0 ? "\n" : "")
        end
    end
end

wordsfromneighbourones("unixdict.txt")
