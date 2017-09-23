use framework "Foundation"

-- SPELLING BY BLOCK ----------------------------------------------------------
on run
    set blocks to map(chars, ¬
        |words|("BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM"))

    script blockSpelled
        on |λ|(s)
            intercalate("  ->  ", ¬
                ap({my |quote|, compose({my |not|, my |null|, ¬
                    curry(my spellWith)'s |λ|(blocks), my toUpper})}, {s}))
        end |λ|
    end script

    unlines(map(blockSpelled, ¬
        {"", "A", "BARK", "BoOK", "TrEAT", "COmMoN", "SQUAD", "conFUsE"}))
end run

-- spellWith :: [(Char, Char)] -> String -> [[(Char, Char)]]
on spellWith(blocks, ccs)
    if |null|(ccs) then
        {{}}
    else
        set {c, cs} to uncons(ccs)

        script matchSequence
            on |λ|(pair)
                if elem(c, pair) then

                    script pairUsed
                        on |λ|(xs)
                            {{pair} & xs}
                        end |λ|
                    end script

                    concatMap(pairUsed, spellWith(|delete|(pair, blocks), cs))
                else
                    {}
                end if
            end |λ|
        end script

        concatMap(matchSequence, blocks)
    end if
end spellWith


-- GENERIC FUNCTIONS ----------------------------------------------------------

-- A list of functions applied to a list of arguments
-- (<*> | ap) :: [(a -> b)] -> [a] -> [b]
on ap(fs, xs)
    set lngFs to length of fs
    set lngXs to length of xs
    set lst to {}
    repeat with i from 1 to lngFs
        tell mReturn(item i of fs)
            repeat with j from 1 to lngXs
                set end of lst to |λ|(contents of (item j of xs))
            end repeat
        end tell
    end repeat
    return lst
end ap

-- chars :: String -> [Char]
on chars(s)
    characters of s
end chars

-- compose :: [(a -> a)] -> (a -> a)
on compose(fs)
    script
        on |λ|(x)
            script
                on |λ|(a, f)
                    mReturn(f)'s |λ|(a)
                end |λ|
            end script

            foldr(result, x, fs)
        end |λ|
    end script
end compose

-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set lst to {}
    set lng to length of xs
    tell mReturn(f)
        repeat with i from 1 to lng
            set lst to (lst & |λ|(contents of item i of xs, i, xs))
        end repeat
    end tell
    return lst
end concatMap

-- curry :: (Script|Handler) -> Script
on curry(f)
    script
        on |λ|(a)
            script
                on |λ|(b)
                    |λ|(a, b) of mReturn(f)
                end |λ|
            end script
        end |λ|
    end script
end curry

-- delete :: Eq a => a -> [a] -> [a]
on |delete|(x, xs)
    set mbIndex to elemIndex(x, xs)
    set lng to length of xs

    if mbIndex is not missing value then
        if lng > 1 then
            if mbIndex = 1 then
                items 2 thru -1 of xs
            else if mbIndex = lng then
                items 1 thru -2 of xs
            else
                tell xs to items 1 thru (mbIndex - 1) & ¬
                    items (mbIndex + 1) thru -1
            end if
        else
            {}
        end if
    else
        xs
    end if
end |delete|

-- elem :: Eq a => a -> [a] -> Bool
on elem(x, xs)
    xs contains x
end elem

-- elemIndex :: a -> [a] -> Maybe Int
on elemIndex(x, xs)
    set lng to length of xs
    repeat with i from 1 to lng
        if x = (item i of xs) then return i
    end repeat
    return missing value
end elemIndex

-- foldr :: (a -> b -> a) -> a -> [b] -> a
on foldr(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from lng to 1 by -1
            set v to |λ|(v, item i of xs, i, xs)
        end repeat
        return v
    end tell
end foldr

-- intercalate :: Text -> [Text] -> Text
on intercalate(strText, lstText)
    set {dlm, my text item delimiters} to {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    return strJoined
end intercalate

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

-- null:: [a] -> Bool
on |null|(xs)
    if class of xs is string then
        xs = ""
    else
        xs = {}
    end if
end |null|

-- Lift 2nd class handler function into 1st class script wrapper
-- mReturn :: Handler -> Script
on mReturn(f)
    if class of f is script then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn

-- not :: Bool -> Bool
on |not|(x)
    not x
end |not|

-- quote :: String -> String
on |quote|(x)
    quoted form of x
end |quote|

-- toUpper :: String -> String
on toUpper(str)
    set ca to current application
    ((ca's NSString's stringWithString:(str))'s ¬
        uppercaseStringWithLocale:(ca's NSLocale's currentLocale())) as text
end toUpper

-- uncons :: [a] -> Maybe (a, [a])
on uncons(xs)
    set lng to length of xs
    if lng > 0 then
        if class of xs is string then
            set cs to text items of xs
            {item 1 of cs, rest of cs}
        else
            {item 1 of xs, rest of xs}
        end if
    else
        missing value
    end if
end uncons

-- unlines :: [String] -> String
on unlines(xs)
    intercalate(linefeed, xs)
end unlines

-- words :: String -> [String]
on |words|(s)
    words of s
end |words|
