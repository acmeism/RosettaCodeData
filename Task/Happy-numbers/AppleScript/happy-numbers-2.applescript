-- isHappy :: Int -> Bool
on isHappy(n)

    -- endsInOne :: [Int] -> Int -> Bool
    script endsInOne

        -- sumOfSquaredDigits :: Int -> Int
        script sumOfSquaredDigits

            -- digitSquared :: Int -> Int -> Int
            script digitSquared
                on lambda(a, x)
                    (a + (x as integer) ^ 2) as integer
                end lambda
            end script

            on lambda(n)
                foldl(digitSquared, 0, splitOn("", n as string))
            end lambda
        end script

        -- [Int] -> Int -> Bool
        on lambda(s, n)
            if n = 1 then
                true
            else
                if s contains n then
                    false
                else
                    lambda(s & n, lambda(n) of sumOfSquaredDigits)
                end if
            end if
        end lambda
    end script

    endsInOne's lambda({}, n)
end isHappy


-- TEST
on run

    -- seriesLength :: {n:Int, xs:[Int]} -> Bool
    script seriesLength
        property target : 8

        on lambda(rec)
            length of xs of rec = target of seriesLength
        end lambda
    end script

    -- succTest :: {n:Int, xs:[Int]} -> {n:Int, xs:[Int]}
    script succTest
        on lambda(rec)
            set xs to xs of rec
            set n to n of rec

            script testResult
                on lambda(x)
                    if isHappy(x) then
                        xs & x
                    else
                        xs
                    end if
                end lambda
            end script

            {n:n + 1, xs:testResult's lambda(n)}
        end lambda
    end script

    xs of |until|(seriesLength, succTest, {n:1, xs:{}})

    --> {1, 7, 10, 13, 19, 23, 28, 31}
end run



-- GENERIC FUNCTIONS

-- foldl :: (a -> b -> a) -> a -> [b] -> a
on foldl(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from 1 to lng
            set v to lambda(v, item i of xs, i, xs)
        end repeat
        return v
    end tell
end foldl

-- until :: (a -> Bool) -> (a -> a) -> a -> a
on |until|(p, f, x)
    set mp to mReturn(p)
    set mf to mReturn(f)

    script
        property p : mp's lambda
        property f : mf's lambda

        on lambda(v)
            repeat until p(v)
                set v to f(v)
            end repeat
            return v
        end lambda
    end script

    result's lambda(x)
end |until|

-- splitOn :: Text -> Text -> [Text]
on splitOn(strDelim, strMain)
    set {dlm, my text item delimiters} to {my text item delimiters, strDelim}
    set xs to text items of strMain
    set my text item delimiters to dlm
    return xs
end splitOn

-- Lift 2nd class handler function into 1st class script wrapper
-- mReturn :: Handler -> Script
on mReturn(f)
    if class of f is script then
        f
    else
        script
            property lambda : f
        end script
    end if
end mReturn
