const tfile = download("http://wiki.puzzlers.org/pub/wordlists/unixdict.txt")
const wordarraylist = [[string(c) for c in w] for w in split(read(tfile, String), r"\s+")]

function wordwheel2(wheel, central)
    warr, maxlen = [string(c) for c in wheel], length(wheel)
    returnarraylist = filter(a -> 2 < length(a) <= maxlen && central in a &&
            all(c -> sum(x -> x == c, a) <= sum(x -> x == c, warr), a), wordarraylist)
    return join.(returnarraylist)
end

println(wordwheel2("ndeokgelw", "k"))
