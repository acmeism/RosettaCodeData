--------------------- GENERAL FIZZBUZZ -------------------

-- fizzEtc :: [(Int, String)] -> [Symbol]
on fizzEtc(rules)
    -- A non-finite sequence of fizzEtc symbols,
    -- as defined by the given list of rules.
    script numberOrNoise
        on |λ|(n)
            script ruleMatch
                on |λ|(a, mk)
                    set {m, k} to mk

                    if 0 = (n mod m) then
                        if integer is class of a then
                            k
                        else
                            a & k
                        end if
                    else
                        a
                    end if
                end |λ|
            end script

            foldl(ruleMatch, n, rules)
        end |λ|
    end script

    fmapGen(numberOrNoise, enumFrom(1))
end fizzEtc


--------------------------- TEST -------------------------
on run

    unlines(take(20, ¬
        fizzEtc({{3, "Fizz"}, {5, "Buzz"}, {7, "Baxx"}})))

end run


------------------------- GENERIC ------------------------

-- enumFrom :: Enum a => a -> [a]
on enumFrom(x)
    script
        property v : missing value
        on |λ|()
            if missing value is not v then
                set v to 1 + v
            else
                set v to x
            end if
            return v
        end |λ|
    end script
end enumFrom


-- fmapGen <$> :: (a -> b) -> Gen [a] -> Gen [b]
on fmapGen(f, gen)
    script
        property g : mReturn(f)
        on |λ|()
            set v to gen's |λ|()
            if v is missing value then
                v
            else
                g's |λ|(v)
            end if
        end |λ|
    end script
end fmapGen


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


-- mReturn :: First-class m => (a -> b) -> m (a -> b)
on mReturn(f)
    -- 2nd class handler function lifted into 1st class script wrapper.
    if script is class of f then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn


-- take :: Int -> [a] -> [a]
-- take :: Int -> String -> String
on take(n, xs)
    set ys to {}
    repeat with i from 1 to n
        set v to |λ|() of xs
        if missing value is v then
            return ys
        else
            set end of ys to v
        end if
    end repeat
    return ys
end take


-- unlines :: [String] -> String
on unlines(xs)
    -- A single string formed by the intercalation
    -- of a list of strings with the newline character.
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, linefeed}
    set s to xs as text
    set my text item delimiters to dlm
    s
end unlines
