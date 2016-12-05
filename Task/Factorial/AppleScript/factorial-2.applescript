-- factorial :: Int -> Int
on factorial(x)
    if x > 1 then
        x * (factorial(x - 1))
    else if x = 1 then
        1
    else
        0
    end if
end factorial
