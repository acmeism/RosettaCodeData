-- allEqual :: [String] -> Bool
on allEqual(xs)
    _and(zipWith(my _equal, xs, rest of xs))
end allEqual

-- azSorted :: [String] -> Bool
on azSorted(xs)
    _and(zipWith(my azBeforeOrSame, xs, rest of xs))
end azSorted

-- _equal :: a -> a -> Bool
on _equal(a, b)
    a = b
end _equal

-- azBefore :: String -> String -> Bool
on azBeforeOrSame(a, b)
    a ≥ b
end azBeforeOrSame

-- _and :: [a] -> Bool
on _and(xs)
    foldr(_equal, true, xs)
end _and


-- TEST
on run
    set lstA to ["isiZulu", "isiXhosa", "isiNdebele", "Xitsonga", "Tshivenda", ¬
        "Setswana", "Sesotho sa Leboa", "Sesotho", "English", "Afrikaans"]

    set lstB to ["Afrikaans", "English", "Sesotho", "Sesotho sa Leboa", "Setswana", ¬
        "Tshivenda", "Xitsonga", "isiNdebele", "isiXhosa", "isiZulu"]

    set lstC to ["alpha", "alpha", "alpha", "alpha", "alpha", "alpha", "alpha", ¬
        "alpha", "alpha", "alpha"]


    {allEqual:map(allEqual, [lstA, lstB, lstC]), azSorted:map(azSorted, [lstA, lstB, lstC])}

    -- > {allEqual:{false, false, true}, azSorted:{false, true, true}}
end run



-- GENERIC FUNCTIONS

-- foldr :: (a -> b -> a) -> a -> [b] -> a
on foldr(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from lng to 1 by -1
            set v to lambda(v, item i of xs, i, xs)
        end repeat
        return v
    end tell
end foldr

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

-- zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
on zipWith(f, xs, ys)
    set nx to length of xs
    set ny to length of ys
    if nx < 1 or ny < 1 then
        {}
    else
        set lng to cond(nx < ny, nx, ny)
        set lst to {}
        tell mReturn(f)
            repeat with i from 1 to lng
                set end of lst to lambda(item i of xs, item i of ys)
            end repeat
            return lst
        end tell
    end if
end zipWith

-- cond :: Bool -> (a -> b) -> (a -> b) -> (a -> b)
on cond(bool, f, g)
    if bool then
        f
    else
        g
    end if
end cond

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
