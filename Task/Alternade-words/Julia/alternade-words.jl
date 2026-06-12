function foreachword(wordfile::String, condition::Function; minlen = 0, colwidth = 15, numcols = 6, toshow = 0)
    println("Word source: $wordfile\n")
    words = split(read(wordfile, String), r"\s+")
    dict, shown = Dict(w => 1 for w in words), 0
    for word in words
        if (minlen < 1 || length(word) >= minlen) && (output = condition(word, dict)) != ""
            shown += 1
            print(rpad(output, colwidth), shown % numcols == 0 ? "\n" : "")
            toshow > 0 && toshow < shown && break
        end
    end
end

function isalternade(w, d)
    wodd, weven = (mapreduce(i -> w[i], *, j:2:length(w)) for j in [1,2])
    return haskey(d, wodd) && haskey(d, weven) ? rpad(w, 8) * ": $wodd, $weven" : ""
end

foreachword("unixdict.txt", isalternade, minlen = 6, numcols=1)

