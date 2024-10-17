using Memoize

@memoize function scs(x, y)
    if x == ""
        return y
    elseif y == ""
        return x
    elseif x[1] == y[1]
        return "$(x[1])$(scs(x[2:end], y[2:end]))"
    elseif length(scs(x, y[2:end])) <= length(scs(x[2:end], y))
        return "$(y[1])$(scs(x, y[2:end]))"
    else
        return "$(x[1])$(scs(x[2:end], y))"
    end
end

println(scs("abcbdab", "bdcaba"))
