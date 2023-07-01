digroot(n) = (while n > 9 n = sum(digits(n)) end; n)

function hexwords(wordfile = "unixdict.txt")
    words = lowercase.(split(read(wordfile, String), r"\s+"))
    filter!(w -> length(w) >= 4 && all(c -> c in "abcdef", w), words)
    results = [[w, parse(Int, w, base = 16)] for w in words]
    for a in results
        pushfirst!(a, digroot(a[2]))
    end
    println("Hex words in $wordfile:\nRoot  Word      Base 10\n", "-"^30)
    for a in sort!(results)
        println(rpad(a[1], 6), rpad(a[2], 10), a[3])
    end
    println("Total count of these words: $(length(results)).")
    println("\nHex words with > 3 distinct letters:\nRoot  Word      Base 10\n", "-"^30)
    filter!(a -> length(unique(a[2])) > 3, results)
    for a in results
        println(rpad(a[1], 6), rpad(a[2], 10), a[3])
    end
    println("Total count of those words: $(length(results)).")
end

hexwords()
