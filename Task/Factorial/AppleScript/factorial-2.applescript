-- factorial :: Int -> Int
on factorial(x)
    if x > 1 then
        x * (factorial(x - 1))
    else
        1
    end if
end factorial
