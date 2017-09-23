-- perfectSquaresUpTo :: Int -> [Int]
on perfectSquaresUpTo(n)
    script squared
        -- (Int -> Int)
        on |λ|(x)
            x * x
        end |λ|
    end script

    set realRoot to n ^ (1 / 2)
    set intRoot to realRoot as integer
    set blnNotPerfectSquare to not (intRoot = realRoot)

    map(squared, enumFromTo(1, intRoot - (blnNotPerfectSquare as integer)))
end perfectSquaresUpTo

on run

    perfectSquaresUpTo(100)

end run
