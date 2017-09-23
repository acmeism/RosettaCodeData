-- HAPPY NUMBERS --------------------------------------------------------------

-- isHappy :: Int -> Bool
on isHappy(n)

    -- endsInOne :: [Int] -> Int -> Bool
    script endsInOne

        -- sumOfSquaredDigits :: Int -> Int
        script sumOfSquaredDigits

            -- digitSquared :: Int -> Int -> Int
            script digitSquared
                on |λ|(a, x)
                    (a + (x as integer) ^ 2) as integer
                end |λ|
            end script

            on |λ|(n)
                foldl(digitSquared, 0, splitOn("", n as string))
            end |λ|
        end script

        -- [Int] -> Int -> Bool
        on |λ|(s, n)
            if n = 1 then
                true
            else
                if s contains n then
                    false
                else
                    |λ|(s & n, |λ|(n) of sumOfSquaredDigits)
                end if
            end if
        end |λ|
    end script

    endsInOne's |λ|({}, n)
end isHappy

-- TEST -----------------------------------------------------------------------
on run

    -- seriesLength :: {n:Int, xs:[Int]} -> Bool
    script seriesLength
        property target : 8

        on |λ|(rec)
            length of xs of rec = target of seriesLength
        end |λ|
    end script

    -- succTest :: {n:Int, xs:[Int]} -> {n:Int, xs:[Int]}
    script succTest
        on |λ|(rec)
            tell rec to set {xs, n} to {its xs, its n}

            script testResult
                on |λ|(x)
                    if isHappy(x) then
                        xs & x
                    else
                        xs
                    end if
                end |λ|
            end script

            {n:n + 1, xs:testResult's |λ|(n)}
        end |λ|
    end script

    xs of |until|(seriesLength, succTest, {n:1, xs:{}})

    --> {1, 7, 10, 13, 19, 23, 28, 31}
end run


-- GENERIC FUNCTIONS ----------------------------------------------------------

-- foldl :: (a -> b -> a) -> a -> [b] -> a
on foldl(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from 1 to lng
            set v to |λ|(v, item i of xs, i, xs)
        end repeat
        return v
    end tell
end foldl

-- Lift 2nd class handler function into 1st class script wrapper
-- mReturn :: Handler -> Script
on mReturn(f)
    if class of f is script then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn

-- splitOn :: Text -> Text -> [Text]
on splitOn(strDelim, strMain)
    set {dlm, my text item delimiters} to {my text item delimiters, strDelim}
    set xs to text items of strMain
    set my text item delimiters to dlm
    return xs
end splitOn

-- until :: (a -> Bool) -> (a -> a) -> a -> a
on |until|(p, f, x)
    set mp to mReturn(p)
    set v to x

    tell mReturn(f)
        repeat until mp's |λ|(v)
            set v to |λ|(v)
        end repeat
    end tell
    return v
end |until|
