-- roman :: Int -> String
on roman(n)
    script romanDigits
        on lambda(a, lstPair)
            set n to remainder of a
            set v to item 1 of lstPair

            if v > n then
                a
            else
                {remainder:n mod v, roman:(roman of a) & ¬
                    replicate(n div v, item 2 of lstPair)}
            end if
        end lambda
    end script

    roman of foldl(romanDigits, {remainder:n, roman:""}, ¬
        [[1000, "M"], [900, "CM"], [500, "D"], ¬
            [400, "CD"], [100, "C"], [90, "XC"], [50, "L"], [40, "XL"], ¬
            [10, "X"], [9, "IX"], [5, "V"], [4, "IV"], [1, "I"]])
end roman


-- TEST

on run
    map(roman, [2016, 1990, 2008, 2000, 1666])

    --> {"MMXVI", "MCMXC", "MMVIII", "MM", "MDCLXVI"}
end run



-- GENERIC LIBRARY FUNCTIONS

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

-- map :: (a -> b) -> [a] -> [b]
on map(f, xs)
    tell mReturn(f)
        set lng to length of xs
        set lst to {}
        repeat with i from 1 to lng
            set end of lst to lambda(item i of xs, i, xs)
        end repeat
        return lst
    end tell
end map

-- Egyptian multiplication - progressively doubling a list, appending
-- stages of doubling to an accumulator where needed for binary
-- assembly of a target length

-- replicate :: Int -> a -> [a]
on replicate(n, a)
    if class of a is list then
        set out to {}
    else
        set out to ""
    end if
    if n < 1 then return out
    set dbl to a

    repeat while (n > 1)
        if (n mod 2) > 0 then set out to out & dbl
        set n to (n div 2)
        set dbl to (dbl & dbl)
    end repeat
    return out & dbl
end replicate

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
