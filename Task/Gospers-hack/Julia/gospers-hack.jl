function gospers_hack(x)
    c = x & -x
    r = x + c
    return (((r ⊻ x) >> 2) ÷ c) | r
end

for starting in [1, 3, 7, 15]
    results = accumulate((x, _) -> gospers_hack(x), 1:10, init = starting)
    println(lpad(starting, 2), ":  ", join(map(string, results), ", "))
end
