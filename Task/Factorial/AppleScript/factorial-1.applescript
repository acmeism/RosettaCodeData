on factorial(x)
    if x < 0 then return 0
    set R to 1
    repeat while x > 1
        set {R, x} to {R * x, x - 1}
    end repeat
    return R
end factorial
