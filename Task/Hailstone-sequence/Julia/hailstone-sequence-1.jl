function hailstonelength(n::Integer)
    len = 1
    while n > 1
        n = ifelse(iseven(n), n ÷ 2, 3n + 1)
        len += 1
    end
    return len
end

@show hailstonelength(27); nothing
@show findmax([hailstonelength(i) for i in 1:100_000]); nothing
