------ CONCATENATION OF TWO IDENTICAL BINARY STRINGS -----

-- binaryTwin :: Int -> (Int, String)
on binaryTwin(n)
    -- A tuple of an integer m and a string s, where
    -- s is a self-concatenation of the binary
    -- represention of n, and m is the integer value of s.

    set b to showBinary(n)
    set s to b & b
    {readBinary(s), s}
end binaryTwin


--------------------------- TEST -------------------------
on run
    script p
        on |λ|(pair)
            1000 > item 1 of pair
        end |λ|
    end script

    script format
        on |λ|(pair)
            set {n, s} to pair

            (n as string) & " -> " & s
        end |λ|
    end script

    unlines(map(format, ¬
        takeWhile(p, ¬
            fmap(binaryTwin, enumFrom(1)))))
end run


------------------------- GENERIC ------------------------

-- enumFrom :: Int -> [Int]
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


-- fmap <$> :: (a -> b) -> Gen [a] -> Gen [b]
on fmap(f, gen)
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
end fmap


-- foldr :: (a -> b -> b) -> b -> [a] -> b
on foldr(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from lng to 1 by -1
            set v to |λ|(item i of xs, v, i, xs)
        end repeat
        return v
    end tell
end foldr


-- map :: (a -> b) -> [a] -> [b]
on map(f, xs)
    -- The list obtained by applying f
    -- to each element of xs.
    tell mReturn(f)
        set lng to length of xs
        set lst to {}
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of xs, i, xs)
        end repeat
        return lst
    end tell
end map


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


-- quotRem :: Int -> Int -> (Int, Int)
on quotRem(m, n)
    {m div n, m mod n}
end quotRem


-- readBinary :: String -> Int
on readBinary(s)
    -- The integer value of the binary string s
    script go
        on |λ|(c, en)
            set {e, n} to en
            set v to ((id of c) - 48)

            {2 * e, v * e + n}
        end |λ|
    end script

    item 2 of foldr(go, {1, 0}, s)
end readBinary


-- showBinary :: Int -> String
on showBinary(n)
    script binaryChar
        on |λ|(n)
            character id (48 + n)
        end |λ|
    end script
    showIntAtBase(2, binaryChar, n, "")
end showBinary


-- showIntAtBase :: Int -> (Int -> Char) -> Int -> String -> String
on showIntAtBase(base, toDigit, n, rs)
    script go
        property f : mReturn(toDigit)
        on |λ|(nd_, r)
            set {n, d} to nd_
            set r_ to f's |λ|(d) & r
            if n > 0 then
                |λ|(quotRem(n, base), r_)
            else
                r_
            end if
        end |λ|
    end script
    |λ|(quotRem(n, base), rs) of go
end showIntAtBase


-- takeWhile :: (a -> Bool) -> Generator [a] -> [a]
on takeWhile(p, xs)
    set ys to {}
    set v to |λ|() of xs
    tell mReturn(p)
        repeat while (|λ|(v))
            set end of ys to v
            set v to xs's |λ|()
        end repeat
    end tell
    return ys
end takeWhile


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
