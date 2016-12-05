use framework "Foundation"
use scripting additions

on sort:lst
    tell current application
        return ((its (NSArray's arrayWithArray:lst))'s ¬
            sortedArrayUsingDescriptors:{its (NSSortDescriptor's ¬
                sortDescriptorWithKey:"self" ascending:true selector:"compare:")}) as list
    end tell
end sort:

on run

    map(sort_, [[9, 1, 8, 2, 8, 3, 7, 0, 4, 6, 5], ¬
        ["alpha", "beta", "gamma", "delta", "epsilon", "zeta", "eta", "theta", "iota", "kappa", "lambda", "mu"]])

end run


-- GENERIC FUNCTION FOR THE TEST

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
