function isogram(word)
    wchars, uchars = collect(word), unique(collect(word))
    ulen, wlen = length(uchars), length(wchars)
    (wlen == 1 || ulen == wlen) && return 1
    n = count(==(first(uchars)), wchars)
    return all(i -> count(==(uchars[i]), wchars) == n, 2:ulen) ? n : 0
end

words = split(lowercase(read("documents/julia/unixdict.txt", String)), r"\s+")
orderlengthtuples = [(isogram(w), length(w), w) for w in words]

tcomp(x, y) = (x[1] != y[1] ? y[1] < x[1] : x[2] != y[2] ? y[2] < x[2] : x[3] < y[3])

nisograms = sort!(filter(t -> t[1] > 1, orderlengthtuples), lt = tcomp)
heterograms = sort!(filter(t -> t[1] == 1 && length(t[3]) > 10, orderlengthtuples), lt = tcomp)

println("N-Isogram   N  Length\n", "-"^24)
foreach(t -> println(rpad(t[3], 8), lpad(t[1], 5), lpad(t[2], 5)), nisograms)
println("\nHeterogram   Length\n", "-"^20)
foreach(t -> println(rpad(t[3], 12), lpad(t[2], 5)), heterograms)
