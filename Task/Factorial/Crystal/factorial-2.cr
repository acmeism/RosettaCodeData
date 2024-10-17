def factorial(x : Int)
    if x <= 1
        return 1
    end
    return x * factorial(x - 1)
end
