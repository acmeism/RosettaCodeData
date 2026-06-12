function anadromes(minsize, csense = true, fname = "words.txt")
    words = Set(filter(w -> length(w) >= minsize, split((csense ? identity : lowercase)(read(fname, String)), r"\s+")))
    found = [(w, reverse(w)) for w in words if (r = reverse(w)) in words && w < r]
    println("Total $(length(found)) case $(csense ? "" : in)sensitive anadrome pairs found.")
    foreach(a -> println(a[1], " <=> ", a[2]), sort!(found))
end

anadromes(7)
anadromes(7, false)
