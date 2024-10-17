"""
    The ADFGVX cipher.
    See also eg. https://www.nku.edu/~christensen/092hnr304%20ADFGVX.pdf
"""

using Random

""" The WWI German ADFGVX cipher. """
struct ADFGVX
    polybius::Vector{Char}
    pdim::Int
    key::Vector{Char}
    keylen::Int
    alphabet::Vector{Char}
    encode::Dict{Char, Vector{Char}}
    decode::Dict{Vector{Char}, Char}
end

""" ADFGVX constructor, takes 2 strings, option for third string if polybius len != 36 """
function ADFGVX(s, k, alph = "ADFGVX")
    poly = collect(uppercase(s))
    pdim = isqrt(length(poly))
    al = collect(uppercase(alph))
    enco::Dict = Dict([(poly[(i - 1) * pdim + j] => [al[i], al[j]])
        for i in 1:pdim, j in 1:pdim])
    deco = Dict(last(p) => first(p) for p in enco)
    @assert pdim^2 == length(poly) && pdim == length(al)
    return ADFGVX(poly, pdim, collect(uppercase(k)), length(k), al, enco, deco)
end

""" Encrypt with the ADFGVX cipher. """
function encrypt(s::String, k::ADFGVX)
    chars = reduce(vcat, [k.encode[c] for c in
        filter(c -> c in k.polybius, collect(uppercase(s)))])
    colvecs = [lett => chars[i:k.keylen:length(chars)] for (i, lett) in enumerate(k.key)]
    sort!(colvecs, lt = (x, y) -> first(x) < first(y))
    return String(mapreduce(p -> last(p), vcat, colvecs))
end

""" Decrypt with the ADFGVX cipher. Does not depend on spacing of encoded text """
function decrypt(s::String, k::ADFGVX)
    chars = filter(c -> c in k.alphabet, collect(uppercase(s)))
    sortedkey = sort(collect(k.key))
    order = [findfirst(c -> c == ch, k.key) for ch in sortedkey]
    originalorder = [findfirst(c -> c == ch, sortedkey) for ch in k.key]
    a, b = divrem(length(chars), k.keylen)
    strides = [a + (b >= i ? 1 : 0) for i in order]           # shuffled column lengths
    starts = accumulate(+, strides[begin:end-1], init=1)      # shuffled starts of columns
    pushfirst!(starts, 1)                                     # starting index
    ends = [starts[i] + strides[i] - 1 for i in 1:k.keylen]   # shuffled ends of columns
    cols = [chars[starts[i]:ends[i]] for i in originalorder]  # get reordered columns
    pairs, nrows = Char[], (length(chars) - 1) ÷ k.keylen + 1 # recover the rows
    for i in 1:nrows, j in 1:k.keylen
        (i - 1) * k.keylen + j > length(chars) && break
        push!(pairs, cols[j][i])
    end
    return String([k.decode[[pairs[i], pairs[i + 1]]] for i in 1:2:length(pairs)-1])
end

const POLYBIUS = String(shuffle(collect("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")))
const KEY = read("unixdict.txt", String) |>
    v -> split(v, r"\s+") |>
    v -> filter(w -> (n = length(w); n == 9 && n == length(unique(collect(w)))), v) |>
    shuffle |> first |> uppercase
const SECRETS, message = ADFGVX(POLYBIUS, KEY), "ATTACKAT1200AM"
println("Polybius: $POLYBIUS, Key: $KEY")
println("Message: $message")
encoded = encrypt(message, SECRETS)
decoded = decrypt(encoded, SECRETS)
println("Encoded: $encoded")
println("Decoded: $decoded")
