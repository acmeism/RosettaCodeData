function markovtext(txt::AbstractString, klen::Integer, maxchlen::Integer)
    words = matchall(r"\w+", txt)
    dict = Dict()
    for i in 1:length(words)-klen
        k = join(words[i:i+klen-1], " ")
        v = words[i+klen]
        if haskey(dict, k)
            dict[k] = push!(dict[k], v)
        else
            dict[k] = [v]
        end
    end
    keytext = rand(collect(keys(dict)))
    outtext = keytext
    lasttext = outtext
    while length(outtext) < maxchlen
        lasttext = outtext
        valtext = rand(dict[keytext])
        outtext = outtext * " " * valtext
        keytext = replace(keytext, r"^\w+\s+(.+)", s"\1") * " " * valtext
    end
    return lasttext
end

txt = readstring(download("http://paulo-jorente.de/text/alice_oz.txt"))
println(markovtext(txt, 3, 200))
