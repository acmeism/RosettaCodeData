list = ["1a3c52debeffd", "2b6178c97a938stf", "3ycxdb1fgxa2yz"]

onceineachstring(list) = filter(c -> all(w -> count(x -> x == c, w) == 1, list), (sort ∘ unique ∘ prod)(list))

println(onceineachstring(list))
