use AppleScript version "2.4"
use framework "Foundation"
use scripting additions

-- succString :: Bool -> String -> String
on succString(blnPruned, s)
    script go
        on |λ|(w)
            try
                if w contains "." then
                    set v to w as real
                else
                    set v to w as integer
                end if
                {(1 + v) as string}
            on error
                if blnPruned then
                    {}
                else
                    {w}
                end if
            end try
        end |λ|
    end script
    unwords(concatMap(go, |words|(s)))
end succString


-- TEST ---------------------------------------------------
on run
    script test
        on |λ|(bln)
            succString(bln, ¬
                "41 pine martens in 1491.3 -1.5 mushrooms ≠ 136")
        end |λ|
    end script
    unlines(map(test, {true, false}))
end run

--> 42 1492.3 -0.5 137
--> 42 pine martens in 1492.3 -0.5 mushrooms ≠ 137

-- GENERIC ------------------------------------------------

-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set lng to length of xs
    set acc to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set acc to acc & |λ|(item i of xs, i, xs)
        end repeat
    end tell
    return acc
end concatMap

-- map :: (a -> b) -> [a] -> [b]
on map(f, xs)
    tell mReturn(f)
        set lng to length of xs
        set lst to {}
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of xs, i, xs)
        end repeat
        return lst
    end tell
end map

-- Lift 2nd class handler function into 1st class script wrapper
-- mReturn :: First-class m => (a -> b) -> m (a -> b)
on mReturn(f)
    if class of f is script then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn

-- unlines :: [String] -> String
on unlines(xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, linefeed}
    set str to xs as text
    set my text item delimiters to dlm
    str
end unlines

-- unwords :: [String] -> String
on unwords(xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, space}
    set s to xs as text
    set my text item delimiters to dlm
    return s
end unwords

-- words :: String -> [String]
on |words|(s)
    set ca to current application
    (((ca's NSString's stringWithString:(s))'s ¬
        componentsSeparatedByCharactersInSet:(ca's ¬
            NSCharacterSet's whitespaceAndNewlineCharacterSet()))'s ¬
        filteredArrayUsingPredicate:(ca's ¬
            NSPredicate's predicateWithFormat:"0 < length")) as list
end |words|
