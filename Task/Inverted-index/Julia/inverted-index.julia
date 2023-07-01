function makedoubleindex(files)
    idx = Dict{String, Dict}()
    for file in files
        str = lowercase(read(file, String))
        words = split(str, r"\s+")
        for word in words
            if !haskey(idx, word)
                idx[word] = Dict{String, Int}()
            elseif !haskey(idx[word], file)
                (idx[word])[file] = 1
            else
                (idx[word])[file] += 1
            end
        end
    end
    idx
end

function wordsearch(dict, words::Vector{String})
    for word in words
        if haskey(dict, word)
            for (f, n) in dict[word]
                println("File $f contains $n instances of <$word>.")
            end
        else
            println("No instances of \"$word\" were found.")
        end
    end
end
wordsearch(dict, word::String) = wordsearch(dict, [word])


const filenames = ["file1.txt", "file2.txt", "file3.txt"]
const didx = makedoubleindex(filenames)
const searchterms = ["forehead", "of", "hand", "a", "foot"]
wordsearch(didx, searchterms)
