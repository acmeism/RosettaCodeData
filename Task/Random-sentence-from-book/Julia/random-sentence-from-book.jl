""" weighted random pick of items in a Dict{String, Int} where keys are words, values counts """
function weightedrandompick(dict, total)
    n = rand(1:total)
    for (key, value) in dict
        n -= value
        if n <= 0
            return key
        end
    end
    return last(keys(dict))
end

let
    """ Read in the book "The War of the Worlds", by H. G. Wells. """
    wotw_uri =  "http://www.gutenberg.org/files/36/36-0.txt"
    wfile = "war_of_the_worlds.txt"
    stat(wfile).size == 0 && download(wotw_uri, wfile)  # download if file not here already
    text = read(wfile, String)

    """skip to start of book and prune end """
    startphrase, endphrase = "No one would have believed", "she has counted me, among the dead"
    text = text[findfirst(startphrase, text).start:findlast(endphrase, text).stop]

    """ Remove extraneous punctuation, but keep at least sentence-ending punctuation characters . ! and ? """
    text = replace(replace(text, r"[^01-9a-zA-Z\.\?\!’,]" => " "), r"([.?!])" => s" \1")
    words = split(text, r"\s+")
    for (i, w) in enumerate(words)
        w != "I" && i > 1 && words[i - 1] in [".", "?", "!"] && (words[i] = lowercase(words[i]))
    end

    """ Keep account of what words follow words and how many times it is seen. Treat sentence terminators
       (?.!) as words too. Keep account of what words follow two words and how many times it is seen.
    """
    follows, follows2 = Dict{String, Dict{String, Int}}(), Dict{String, Dict{String, Int}}()
    afterstop, wlen = Dict{String, Int}(), length(words)
    for (i, w) in enumerate(@view words[1:end-1])
        d = get!(follows, w, Dict(words[i + 1] => 0))
        get!(d, words[i + 1], 0)
        d[words[i + 1]] += 1
        if w in [".", "?", "!"]
            d = get!(afterstop, words[i + 1], 0)
            afterstop[words[i + 1]] += 1
        end
        (i > wlen - 2) && continue
        w2 = w * " " * words[i + 1]
        d = get!(follows2, w2, Dict(words[i + 2] => 0))
        get!(d, words[i + 2], 0)
        d[words[i + 2]] += 1
    end
    followsums = Dict(key => sum(values(follows[key])) for key in keys(follows))
    follow2sums = Dict(key => sum(values(follows2[key])) for key in keys(follows2))
    afterstopsum = sum(values(afterstop))

   """ Assume that a sentence starts with a not to be shown full-stop character then use a weighted
       random choice of the possible words that may follow a full-stop to add to the sentence.
   """
    function makesentence()
        firstword = weightedrandompick(afterstop, afterstopsum)
        sentencewords = [firstword, weightedrandompick(follows[firstword], followsums[firstword])]
        while !(sentencewords[end] in [".", "?", "!"])
            w2 = sentencewords[end-1] * " " * sentencewords[end]
            if haskey(follows2, w2)
                push!(sentencewords, weightedrandompick(follows2[w2], follow2sums[w2]))
            else
                push!(sentencewords, weightedrandompick(afterstop, afterstopsum))
            end
        end
        sentencewords[1] = uppercase(firstword[1]) * (length(firstword) > 1 ? firstword[2:end] : "")
        println(join(sentencewords[1:end-1], " ") * sentencewords[end] * "\n")
    end
    # Print 3 weighted random pick sentences
    makesentence(); makesentence(); makesentence()
end
