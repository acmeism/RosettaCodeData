function compressLZW(decompressed::String)
    dictsize = 256
    dict     = Dict{String,Int}(string(Char(i)) => i for i in 0:dictsize)
    result   = Vector{Int}(undef, 0)
    w        = ""
    for c in decompressed
        wc = string(w, c)
        if haskey(dict, wc)
            w = wc
        else
            push!(result, dict[w])
            dict[wc]  = dictsize
            dictsize += 1
            w        = string(c)
        end
    end
    if !isempty(w) push!(result, dict[w]) end
    return result
end

function decompressLZW(compressed::Vector{Int})
    dictsize = 256
    dict     = Dict{Int,String}(i => string('\0' + i) for i in 0:dictsize)
    result   = IOBuffer()
    w        = string(Char(popfirst!(compressed)))
    write(result, w)
    for k in compressed
        if haskey(dict, k)
            entry = dict[k]
        elseif k == dictsize
            entry = string(w, w[1])
        else
            error("bad compressed k: $k")
        end
        write(result, entry)
        dict[dictsize] = string(w, entry[1])
        dictsize += 1
        w = entry
    end
    return String(take!(result))
end

original     = ["0123456789", "TOBEORNOTTOBEORTOBEORNOT", "dudidudidudida"]
compressed   = compressLZW.(original)
decompressed = decompressLZW.(compressed)

for (word, comp, decomp) in zip(original, compressed, decompressed)
    comprate = (length(word) - length(comp)) / length(word) * 100
    println("Original: $word\n-> Compressed: $comp (compr.rate: $(round(comprate, digits=2))%)\n-> Decompressed: $decomp")
end
