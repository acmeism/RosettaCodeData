on run

    filter(xmasIsSunday, range(2008, 2121))

end run


-- xmasIsSunday :: Int -> Bool
on xmasIsSunday(y)
    tell (current date)
        set {its year, its month, its day, its time} to {y, 12, 25, 0}
        return its weekday is Sunday
    end tell
end xmasIsSunday



-- GENERIC FUNCTIONS

-- filter :: (a -> Bool) -> [a] -> [a]
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

-- range :: Int -> Int -> [Int]
on range(m, n)
    set lng to (n - m) + 1
    set base to m - 1
    set lst to {}
    repeat with i from 1 to lng
        set end of lst to i + base
    end repeat
    return lst
end range
