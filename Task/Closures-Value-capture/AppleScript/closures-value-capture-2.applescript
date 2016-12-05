on run

    lambda() of (item 3 of (map(closure, range(1, 10))))

end run

on closure(x)
    script
        on lambda()
            return x * x
        end lambda
    end script
end closure



-- GENERIC FUNCTIONS

-- map :: (a -> b) -> [a] -> [b]
on map(f, xs)
    script mf
        property lambda : f
    end script
    set lng to length of xs
    set lst to {}
    repeat with i from 1 to lng
        set end of lst to mf's lambda(item i of xs, i, xs)
    end repeat
    return lst
end map


-- range :: Int -> Int -> Int
on range(m, n)
    set lng to (n - m) + 1
    set base to m - 1
    set lst to {}
    repeat with i from 1 to lng
        set end of lst to i + base
    end repeat
    return lst
end range
