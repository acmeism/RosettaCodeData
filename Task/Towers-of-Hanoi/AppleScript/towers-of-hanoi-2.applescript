-- hanoi :: Int -> (String, String, String) -> [(String, String)]
on hanoi(n, {a, b, c})
    if n > 0 then
        hanoi(n - 1, {a, c, b}) & {{a, b}} & hanoi(n - 1, {c, b, a})
    else
        {}
    end if
end hanoi


-- TEST

-- arrow :: (String, String) -> String
on arrow(tuple)
    item 1 of tuple & " -> " & item 2 of tuple
end arrow

on run

    map(arrow, ¬
        hanoi(3, {"left", "right", "mid"}))

    --> {"left -> right", "left -> mid", "right -> mid", "left -> right",
    --    "mid -> left", "mid -> right", "left -> right"}
end run



-- LIBRARY FUNCTIONS

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
