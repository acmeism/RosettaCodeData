lst = readlines("data/unixdict.txt")
filter!(issorted, lst)
filter!(x -> length(x) == maximum(length, lst), lst)
println.(lst)
