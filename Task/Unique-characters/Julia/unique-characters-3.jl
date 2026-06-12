function uniquein2(a)
    s = sort(collect(prod(list)))
    l = length(s)
    return [p[2] for p in enumerate(s) if (p[1] == 1 || p[2] != s[p[1] - 1]) && (p[1] == l || p[2] != s[p[1] + 1])]
end

println(uniquein2(list))

@btime uniquein2(list)
