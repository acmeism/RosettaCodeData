on run

    -- TRADITIONAL STRINGS ---------------------------------------------------

    -- ts :: Array Int (String, String)            -- 天干 tiangan – 10 heavenly stems
    set ts to zip(chars("甲乙丙丁戊己庚辛壬癸"), ¬
        |words|("jiă yĭ bĭng dīng wù jĭ gēng xīn rén gŭi"))

    -- ds :: Array Int (String, String)            -- 地支 dizhi – 12 terrestrial branches
    set ds to zip(chars("子丑寅卯辰巳午未申酉戌亥"), ¬
        |words|("zĭ chŏu yín măo chén sì wŭ wèi shēn yŏu xū hài"))

    -- ws :: Array Int (String, String, String)    -- 五行 wuxing – 5 elements
    set ws to zip3(chars("木火土金水"), ¬
        |words|("mù huǒ tǔ jīn shuǐ"), ¬
        |words|("wood fire earth metal water"))

    -- xs :: Array Int (String, String, String)    -- 十二生肖 shengxiao – 12 symbolic animals
    set xs to zip3(chars("鼠牛虎兔龍蛇馬羊猴鸡狗豬"), ¬
        |words|("shǔ niú hǔ tù lóng shé mǎ yáng hóu jī gǒu zhū"), ¬
        |words|("rat ox tiger rabbit dragon snake horse goat monkey rooster dog pig"))

    -- ys :: Array Int (String, String)            -- 阴阳 yinyang
    set ys to zip(chars("阳阴"), |words|("yáng yīn"))


    -- TRADITIONAL CYCLES ----------------------------------------------------

    script cycles
        on |λ|(y)
            set iYear to y - 4
            set iStem to iYear mod 10
            set iBranch to iYear mod 12
            set {hStem, pStem} to item (iStem + 1) of ts
            set {hBranch, pBranch} to item (iBranch + 1) of ds
            set {hElem, pElem, eElem} to item ((iStem div 2) + 1) of ws
            set {hAnimal, pAnimal, eAnimal} to item (iBranch + 1) of xs
            set {hYinyang, pYinyang} to item ((iYear mod 2) + 1) of ys

            {{show(y), hStem & hBranch, hElem, hAnimal, hYinyang}, ¬
                {"", pStem & pBranch, pElem, pAnimal, pYinyang}, ¬
                {"", show((iYear mod 60) + 1) & "/60", eElem, eAnimal, ""}}
        end |λ|
    end script

    -- FORMATTING ------------------------------------------------------------

    -- fieldWidths :: [[Int]]
    set fieldWidths to {{6, 10, 7, 8, 3}, {6, 11, 8, 8, 4}, {6, 11, 8, 8, 4}}

    script showYear
        script widthStringPairs
            on |λ|(nscs)
                set {ns, cs} to nscs
                zip(ns, cs)
            end |λ|
        end script

        script justifiedRow
            on |λ|(row)
                script
                    on |λ|(ns)
                        set {n, s} to ns
                        justifyLeft(n, space, s)
                    end |λ|
                end script

                concat(map(result, row))
            end |λ|
        end script

        on |λ|(y)
            unlines(map(justifiedRow, ¬
                map(widthStringPairs, ¬
                    zip(fieldWidths, |λ|(y) of cycles))))
        end |λ|
    end script

    -- TEST OUTPUT -----------------------------------------------------------
    intercalate("\n\n", map(showYear, {1935, 1938, 1968, 1972, 1976, 1984, 2017}))
end run


-- GENERIC FUNCTIONS ---------------------------------------------------------

-- chars :: String -> [String]
on chars(s)
    characters of s
end chars

-- concat :: [[a]] -> [a] | [String] -> String
on concat(xs)
    if length of xs > 0 and class of (item 1 of xs) is string then
        set acc to ""
    else
        set acc to {}
    end if
    repeat with i from 1 to length of xs
        set acc to acc & item i of xs
    end repeat
    acc
end concat

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

-- intercalate :: Text -> [Text] -> Text
on intercalate(strText, lstText)
    set {dlm, my text item delimiters} to {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    return strJoined
end intercalate

-- justifyLeft :: Int -> Char -> Text -> Text
on justifyLeft(n, cFiller, strText)
    if n > length of strText then
        text 1 thru n of (strText & replicate(n, cFiller))
    else
        strText
    end if
end justifyLeft

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

-- min :: Ord a => a -> a -> a
on min(x, y)
    if y < x then
        y
    else
        x
    end if
end min

-- minimum :: [a] -> a
on minimum(xs)
    script min
        on |λ|(a, x)
            if x < a or a is missing value then
                x
            else
                a
            end if
        end |λ|
    end script

    foldl(min, missing value, xs)
end minimum

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

-- Egyptian multiplication - progressively doubling a list, appending
-- stages of doubling to an accumulator where needed for binary
-- assembly of a target length

-- replicate :: Int -> a -> [a]
on replicate(n, a)
    set out to {}
    if n < 1 then return out
    set dbl to {a}

    repeat while (n > 1)
        if (n mod 2) > 0 then set out to out & dbl
        set n to (n div 2)
        set dbl to (dbl & dbl)
    end repeat
    return out & dbl
end replicate

-- show :: a -> String
on show(e)
    set c to class of e
    if c = list then
        script serialized
            on |λ|(v)
                show(v)
            end |λ|
        end script

        "[" & intercalate(", ", map(serialized, e)) & "]"
    else if c = record then
        script showField
            on |λ|(kv)
                set {k, ev} to kv
                "\"" & k & "\":" & show(ev)
            end |λ|
        end script

        "{" & intercalate(", ", ¬
            map(showField, zip(allKeys(e), allValues(e)))) & "}"
    else if c = date then
        "\"" & iso8601Z(e) & "\""
    else if c = text then
        "\"" & e & "\""
    else if (c = integer or c = real) then
        e as text
    else if c = class then
        "null"
    else
        try
            e as text
        on error
            ("«" & c as text) & "»"
        end try
    end if
end show

-- unlines :: [String] -> String
on unlines(xs)
    intercalate(linefeed, xs)
end unlines

-- words :: String -> [String]
on |words|(s)
    words of s
end |words|

-- zip :: [a] -> [b] -> [(a, b)]
on zip(xs, ys)
    set lng to min(length of xs, length of ys)
    set lst to {}
    repeat with i from 1 to lng
        set end of lst to {item i of xs, item i of ys}
    end repeat
    return lst
end zip

-- zip3 :: [a] -> [b] -> [c] -> [(a, b, c)]
on zip3(xs, ys, zs)
    script
        on |λ|(x, i)
            [x, item i of ys, item i of zs]
        end |λ|
    end script

    map(result, items 1 thru ¬
        minimum({length of xs, length of ys, length of zs}) of xs)
end zip3
