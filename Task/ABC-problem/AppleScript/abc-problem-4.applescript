use AppleScript version "2.4"
use framework "Foundation"

----------------------- ABC Problem -----------------------

-- spellWith :: [String] -> [Char] -> [[String]]
on spellWith(blocks, cs)
    if 0 < length of cs then
        set x to item 1 of cs
        script go
            on |λ|(b)
                if b contains x then
                    map(my cons(b), ¬
                        spellWith(|delete|(b, blocks), rest of cs))
                else
                    {}
                end if
            end |λ|
        end script
        concatMap(go, blocks)
    else
        {{}}
    end if
end spellWith


-------------------------- TEST ---------------------------
on run
    set blocks to ¬
        words of "BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM"

    script test
        on |λ|(w)
            justifyRight(9, space, quoted("'", w)) & " -> " & ¬
                ({} ≠ spellWith(blocks, characters of toUpper(w)))
        end |λ|
    end script

    unlines(map(test, ¬
        ["", "A", "BARK", "BoOK", "TrEAT", "COmMoN", "SQUAD", "conFUsE"]))
end run


-------------------- GENERIC FUNCTIONS --------------------

-- Just :: a -> Maybe a
on Just(x)
    -- Constructor for an inhabited Maybe (option type) value.
    -- Wrapper containing the result of a computation.
    {type:"Maybe", Nothing:false, Just:x}
end Just


-- Nothing :: Maybe a
on Nothing()
    -- Constructor for an empty Maybe (option type) value.
    -- Empty wrapper returned where a computation is not possible.
    {type:"Maybe", Nothing:true}
end Nothing


-- elemIndex :: Eq a => a -> [a] -> Maybe Int
on elemIndex(x, xs)
    set lng to length of xs
    repeat with i from 1 to lng
        if x = (item i of xs) then return Just(i)
    end repeat
    return Nothing()
end elemIndex


-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set lng to length of xs
    set acc to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set acc to acc & (|λ|(item i of xs, i, xs))
        end repeat
    end tell
    return acc
end concatMap


-- cons :: a -> [a] -> [a]
on cons(x)
    script
        on |λ|(xs)
            {x} & xs
        end |λ|
    end script
end cons


-- delete :: Eq a => a -> [a] -> [a]
on |delete|(x, xs)
    set mbIndex to elemIndex(x, xs)
    set lng to length of xs

    if Nothing of mbIndex then
        xs
    else
        if 1 < lng then
            set i to Just of mbIndex
            if 1 = i then
                items 2 thru -1 of xs
            else if lng = i then
                items 1 thru -2 of xs
            else
                tell xs to items 1 thru (i - 1) & items (i + 1) thru -1
            end if
        else
            {}
        end if
    end if
end |delete|


-- justifyRight :: Int -> Char -> String -> String
on justifyRight(n, cFiller, strText)
    if n > length of strText then
        text -n thru -1 of ((replicate(n, cFiller) as text) & strText)
    else
        strText
    end if
end justifyRight


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


-- quoted :: Char -> String -> String
on quoted(c, s)
    -- string flanked on both sides
    -- by a specified quote character.
    c & s & c
end quoted


-- replicate :: Int -> String -> String
on replicate(n, s)
    set out to ""
    if n < 1 then return out
    set dbl to s

    repeat while (n > 1)
        if (n mod 2) > 0 then set out to out & dbl
        set n to (n div 2)
        set dbl to (dbl & dbl)
    end repeat
    return out & dbl
end replicate


-- toUpper :: String -> String
on toUpper(str)
    set ca to current application
    ((ca's NSString's stringWithString:(str))'s ¬
        uppercaseStringWithLocale:(ca's NSLocale's currentLocale())) as text
end toUpper


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
