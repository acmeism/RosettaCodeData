-- filter :: (a -> Bool) -> [a] -> [a]
-- filter :: (a -> Int -> Bool) -> [a] -> [a]
-- filter :: (a -> Int -> [a] -> Bool) -> [a] -> [a]
on filter(f, xs)
    script mf
        property lambda : f
    end script

    set lst to {}
    set lng to length of xs
    repeat with i from 1 to lng
        set v to item i of xs
        if mf's lambda(v, i, xs) then
            set end of lst to v
        end if
    end repeat
    return lst
end filter


-- Ordinary AppleScript predicate function, rather than a script object

-- isEven :: (a -> Bool)
on isEven(x)
    x mod 2 = 0
end isEven

set lstRange to {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

filter(isEven, lstRange)
