------------------ RUN-LENGTH ENCODING‎‎ -----------------

-- encode :: String -> String
on encode(s)
    script go
        on |λ|(cs)
            if {} ≠ cs then
                set c to text 1 of cs
                set {chunk, residue} to span(eq(c), rest of cs)
                (c & (1 + (length of chunk)) as string) & |λ|(residue)
            else
                ""
            end if
        end |λ|
    end script
    |λ|(characters of s) of go
end encode


-- decode :: String -> String
on decode(s)
    script go
        on |λ|(cs)
            if {} ≠ cs then
                set {ds, residue} to span(my isDigit, rest of cs)
                set n to (ds as string) as integer
                replicate(n, item 1 of cs) & |λ|(residue)
            else
                ""
            end if
        end |λ|
    end script
    |λ|(characters of s) of go
end decode


--------------------------- TEST -------------------------
on run
    set src to ¬
        "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW"
    set encoded to encode(src)
    set decoded to decode(encoded)

    unlines({encoded, decoded, src = decoded})
end run


-------------------- GENERIC FUNCTIONS -------------------

-- eq :: a -> a -> Bool
on eq(a)
    -- True if a and b are equivalent in terms
    -- of the AppleScript (=) operator.
    script go
        on |λ|(b)
            a = b
        end |λ|
    end script
end eq


-- isDigit :: Char -> Bool
on isDigit(c)
    set n to (id of c)
    48 ≤ n and 57 ≥ n
end isDigit


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


-- Egyptian multiplication - progressively doubling a list, appending
-- stages of doubling to an accumulator where needed for binary
-- assembly of a target length
-- replicate :: Int -> String -> String
on replicate(n, s)
    -- Egyptian multiplication - progressively doubling a list,
    -- appending stages of doubling to an accumulator where needed
    -- for binary assembly of a target length
    script p
        on |λ|({n})
            n ≤ 1
        end |λ|
    end script

    script f
        on |λ|({n, dbl, out})
            if (n mod 2) > 0 then
                set d to out & dbl
            else
                set d to out
            end if
            {n div 2, dbl & dbl, d}
        end |λ|
    end script

    set xs to |until|(p, f, {n, s, ""})
    item 2 of xs & item 3 of xs
end replicate


-- span :: (a -> Bool) -> [a] -> ([a], [a])
on span(p, xs)
    -- The longest (possibly empty) prefix of xs
    -- that contains only elements satisfying p,
    -- tupled with the remainder of xs.
    -- span(p, xs) eq (takeWhile(p, xs), dropWhile(p, xs))
    script go
        property mp : mReturn(p)
        on |λ|(vs)
            if {} ≠ vs then
                set x to item 1 of vs
                if |λ|(x) of mp then
                    set {ys, zs} to |λ|(rest of vs)
                    {{x} & ys, zs}
                else
                    {{}, vs}
                end if
            else
                {{}, {}}
            end if
        end |λ|
    end script
    |λ|(xs) of go
end span


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


-- until :: (a -> Bool) -> (a -> a) -> a -> a
on |until|(p, f, x)
    set v to x
    set mp to mReturn(p)
    set mf to mReturn(f)
    repeat until mp's |λ|(v)
        set v to mf's |λ|(v)
    end repeat
    v
end |until|
