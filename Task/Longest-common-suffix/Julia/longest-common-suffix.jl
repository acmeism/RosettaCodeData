function longestcommonsuffix(strings)
    n, nmax = 0, minimum(length, strings)
    nmax == 0 && return ""
    while n <= nmax && all(s -> s[end-n] == strings[end][end-n], strings)
        n += 1
    end
    return strings[1][end-n+1:end]
end

println(longestcommonsuffix(["baabababc","baabc","bbbabc"]))
println(longestcommonsuffix(["baabababc","baabc","bbbazc"]))
println(longestcommonsuffix([""]))
