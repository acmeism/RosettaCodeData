using HTTP

rotate(s, n) = String(circshift(Vector{UInt8}(s), n))

isliketea(w, d) = (n = length(w); n > 2 && any(c -> c != w[1], w) &&
    all(i -> haskey(d, rotate(w, i)), 1:n-1))

function getteawords(listuri)
    req = HTTP.request("GET", listuri)
    wdict = Dict{String, Int}((lowercase(string(x)), 1) for x in split(String(req.body), r"\s+"))
    sort(unique([sort([rotate(word, i) for i in 1:length(word)])
        for word in collect(keys(wdict)) if isliketea(word, wdict)]))
end

foreach(println, getteawords("https://www.mit.edu/~ecprice/wordlist.10000"))
