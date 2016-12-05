-- perfectSquaresUpTo :: Int -> [Int]
on perfectSquaresUpTo(n)
    script squared
        -- (Int -> Int)
        on lambda(x)
            x * x
        end lambda
    end script

    set realRoot to n ^ (1 / 2)
    set intRoot to realRoot as integer
    set blnNotPerfectSquare to not (intRoot = realRoot)

    map(squared, range(1, intRoot - (blnNotPerfectSquare as integer)))
end perfectSquaresUpTo

on run

    perfectSquaresUpTo(100)

end run
