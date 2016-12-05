use framework "Foundation"
use scripting additions

property plstLangs : [{|name|:"English"} & ¬
    {expansions:{N:"north", S:"south", E:"east", W:"west", b:" by "}} & ¬
    {|N|:"N", |NNNE|:"NbE", |NNE|:"N-NE", |NNENE|:"NEbN", |NE|:"NE", |NENEE|:"NEbE"} & ¬
    {|NEE|:"E-NE", |NEEE|:"EbN", |E|:"E", |EEES|:"EbS", |EES|:"E-SE", |EESES|:"SEbE"} & ¬
    {|ES|:"SE", |ESESS|:"SEbS", |ESS|:"S-SE", |ESSS|:"SbE", |S|:"S", |SSSW|:"SbW"} & ¬
    {|SSW|:"S-SW", |SSWSW|:"SWbS", |SW|:"SW", |SWSWW|:"SWbW", |SWW|:"W-SW"} & ¬
    {|SWWW|:"WbS", |W|:"W", |WWWN|:"WbN", |WWN|:"W-NW", |WWNWN|:"NWbW"} & ¬
    {|WN|:"NW", |WNWNN|:"NWbN", |WNN|:"N-NW", |WNNN|:"NbW"}, ¬
    ¬
        {|name|:"Chinese", |N|:"北", |NNNE|:"北微东", |NNE|:"东北偏北"} & ¬
    {|NNENE|:"东北微北", |NE|:"东北", |NENEE|:"东北微东", |NEE|:"东北偏东"} & ¬
    {|NEEE|:"东微北", |E|:"东", |EEES|:"东微南", |EES|:"东南偏东", |EESES|:"东南微东"} & ¬
    {|ES|:"东南", |ESESS|:"东南微南", |ESS|:"东南偏南", |ESSS|:"南微东", |S|:"南"} & ¬
    {|SSSW|:"南微西", |SSW|:"西南偏南", |SSWSW|:"西南微南", |SW|:"西南"} & ¬
    {|SWSWW|:"西南微西", |SWW|:"西南偏西", |SWWW|:"西微南", |W|:"西"} & ¬
    {|WWWN|:"西微北", |WWN|:"西北偏西", |WWNWN|:"西北微西", |WN|:"西北"} & ¬
    {|WNWNN|:"西北微北", |WNN|:"西北偏北", |WNNN|:"北微西"}]

--  Scale invariant keys for points of the compass
-- (allows us to look up a translation for one scale of compass (32 here)
-- for use in another size of compass (8 or 16 points)
-- (Also semi-serviceable as more or less legible keys without translation)

-- compassKeys :: Int -> [String]
on compassKeys(intDepth)
    -- Simplest compass divides into two hemispheres
    -- with one peak of ambiguity to the left,
    -- and one to the right  (encoded by the commas in this list):
    set urCompass to ["N", "S", "N"]

    -- Necessity drives recursive subdivision of broader directions, shrinking
    -- boxes down to a workable level of precision:
    script subdivision
        on lambda(lstCompass, N)
            if N ≤ 1 then
                lstCompass
            else
                script subKeys
                    on lambda(a, x, i, xs)
                        -- Borders between N and S engender E and W.
                        -- further subdivisions (boxes) concatenate their two parent keys.
                        if i > 1 then
                            cond(N = intDepth, ¬
                                a & {cond(x = "N", "W", "E")} & x, ¬
                                a & {item (i - 1) of xs & x} & x)
                        else
                            a & x
                        end if
                    end lambda
                end script

                lambda(foldl(subKeys, {}, lstCompass), N - 1)
            end if
        end lambda
    end script

    tell subdivision to items 1 thru -2 of lambda(urCompass, intDepth)
end compassKeys

-- pointIndex :: Int -> Num -> String
on pointIndex(power, degrees)
    set nBoxes to 2 ^ power
    set i to round (degrees + (360 / (nBoxes * 2))) mod 360 * nBoxes / 360 rounding up
    cond(i > 0, i, 1)
end pointIndex

-- pointNames :: Int -> Int -> [String]
on pointNames(precision, iBox)
    set k to item iBox of compassKeys(precision)

    script translation
        on lambda(recLang)
            set maybeTrans to keyValue(recLang, k)
            set strBrief to cond(maybeTrans is missing value, k, maybeTrans)

            set recExpand to keyValue(recLang, "expansions")

            if recExpand is not missing value then
                script expand
                    on lambda(c)
                        set t to keyValue(recExpand, c)
                        cond(t is not missing value, t, c)
                    end lambda
                end script
                set strName to (intercalate(cond(precision > 5, " ", ""), ¬
                    map(expand, characters of strBrief)))
                toUpper(text item 1 of strName) & text items 2 thru -1 of strName
            else
                strBrief
            end if
        end lambda
    end script

    map(translation, plstLangs)
end pointNames

-- maxLen :: [String] -> Int
on maxLen(xs)
    -- compareByLength = (String, String) -> (-1 | 0 | 1)
    script compareByLength
        on lambda(a, b)
            set {intA, intB} to {length of a, length of b}
            cond(intA < intB, -1, cond(intA > intB, 1, 0))
        end lambda
    end script

    length of maximumBy(compareByLength, xs)
end maxLen

-- alignRight :: Int -> String -> String
on alignRight(nWidth, x)
    justifyRight(nWidth, space, x)
end alignRight

-- alignLeft :: Int -> String -> String
on alignLeft(nWidth, x)
    justifyLeft(nWidth, space, x)
end alignLeft

-- show :: asString => a -> Text
on show(x)
    x as string
end show

-- compassTable :: Int -> [Num] -> Maybe String
on compassTable(precision, xs)
    if precision < 1 then
        missing value
    else
        set intPad to 2
        set rightAligned to curry(alignRight)
        set leftAligned to curry(alignLeft)
        set join to curry(my intercalate)

        -- INDEX COLUMN
        set lstIndex to map(lambda(precision) of curry(pointIndex), xs)
        set lstStrIndex to map(show, lstIndex)
        set nIndexWidth to maxLen(lstStrIndex)
        set colIndex to map(lambda(nIndexWidth + intPad) of rightAligned, lstStrIndex)

        -- ANGLES COLUMN
        script degreeFormat
            on lambda(x)
                set {c, m} to splitOn(".", x as string)
                c & "." & (text 1 thru 2 of (m & "0")) & "°"
            end lambda
        end script
        set lstAngles to map(degreeFormat, xs)
        set nAngleWidth to maxLen(lstAngles) + intPad
        set colAngles to map(lambda(nAngleWidth) of rightAligned, lstAngles)

        -- NAMES COLUMNS
        script precisionNames
            on lambda(iBox)
                pointNames(precision, iBox)
            end lambda
        end script

        set lstTrans to transpose(map(precisionNames, lstIndex))
        set lstTransWidths to map(maxLen, lstTrans)

        script spacedNames
            on lambda(lstLang, i)
                map(lambda((item i of lstTransWidths) + 2) of leftAligned, lstLang)
            end lambda
        end script

        set colsTrans to map(spacedNames, lstTrans)

        -- TABLE
        intercalate(linefeed, ¬
            map(lambda("") of join, ¬
                transpose({colIndex} & {colAngles} & ¬
                    {replicate(length of lstIndex, "  ")} & colsTrans)))
    end if
end compassTable



-- TEST
on run

    set xs to [0.0, 16.87, 16.88, 33.75, 50.62, 50.63, 67.5, 84.37, ¬
        84.38, 101.25, 118.12, 118.13, 135.0, 151.87, 151.88, 168.75, ¬
        185.62, 185.63, 202.5, 219.37, 219.38, 236.25, 253.12, 253.13, ¬
        270.0, 286.87, 286.88, 303.75, 320.62, 320.63, 337.5, 354.37, ¬
        354.38]

    --   If we supply other precisions, like 4 or 6, (2^n -> 16 or 64 boxes)
    --    the bearings will be divided amongst smaller or larger numbers of boxes,
    --    either using name translations retrieved by the generic hash
    --    or using the keys of the hash itself (combined with any expansions)
    --    to substitute for missing names for very finely divided boxes.

    compassTable(5, xs) -- // 2^5  -> 32 boxes

end run


-- GENERIC FUNCTIONS

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

-- foldl :: (a -> b -> a) -> a -> [b] -> a
on foldl(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from 1 to lng
            set v to lambda(v, item i of xs, i, xs)
        end repeat
        return v
    end tell
end foldl

-- curry :: (Script|Handler) -> Script
on curry(f)
    script
        on lambda(a)
            script
                on lambda(b)
                    lambda(a, b) of mReturn(f)
                end lambda
            end script
        end lambda
    end script
end curry

-- transpose :: [[a]] -> [[a]]
on transpose(xss)
    script column
        on lambda(_, iCol)
            script row
                on lambda(xs)
                    item iCol of xs
                end lambda
            end script

            map(row, xss)
        end lambda
    end script

    map(column, item 1 of xss)
end transpose

-- maximumBy :: (a -> a -> Ordering) -> [a] -> a
on maximumBy(f, xs)
    set cmp to mReturn(f)
    script max
        on lambda(a, b)
            if a is missing value or cmp's lambda(a, b) < 0 then
                b
            else
                a
            end if
        end lambda
    end script

    foldl(max, missing value, xs)
end maximumBy

-- splitOn :: Text -> Text -> [Text]
on splitOn(strDelim, strMain)
    set {dlm, my text item delimiters} to {my text item delimiters, strDelim}
    set xs to text items of strMain
    set my text item delimiters to dlm
    return xs
end splitOn

-- intercalate :: Text -> [Text] -> Text
on intercalate(strText, lstText)
    set {dlm, my text item delimiters} to {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    return strJoined
end intercalate

-- keyValue :: Record -> String -> Maybe String
on keyValue(rec, strKey)
    set ca to current application
    set v to (ca's NSDictionary's dictionaryWithDictionary:rec)'s objectForKey:strKey
    if v is not missing value then
        item 1 of ((ca's NSArray's arrayWithObject:v) as list)
    else
        missing value
    end if
end keyValue

-- toLower :: String -> String
on toLower(str)
    set ca to current application
    ((ca's NSString's stringWithString:(str))'s ¬
        lowercaseStringWithLocale:(ca's NSLocale's currentLocale())) as text
end toLower

-- toUpper :: String -> String
on toUpper(str)
    set ca to current application
    ((ca's NSString's stringWithString:(str))'s ¬
        uppercaseStringWithLocale:(ca's NSLocale's currentLocale())) as text
end toUpper

-- toTitle :: String -> String
on toTitle(str)
    set ca to current application
    ((ca's NSString's stringWithString:(str))'s ¬
        capitalizedStringWithLocale:(ca's NSLocale's currentLocale())) as text
end toTitle


-- justifyLeft :: Int -> Char -> Text -> Text
on justifyLeft(N, cFiller, strText)
    if N > length of strText then
        text 1 thru N of (strText & replicate(N, cFiller))
    else
        strText
    end if
end justifyLeft

-- justifyRight :: Int -> Char -> Text -> Text
on justifyRight(N, cFiller, strText)
    if N > length of strText then
        text -N thru -1 of ((replicate(N, cFiller) as text) & strText)
    else
        strText
    end if
end justifyRight

-- replicate :: Int -> a -> [a]
on replicate(N, a)
    set out to {}
    if N < 1 then return out
    set dbl to {a}

    repeat while (N > 1)
        if (N mod 2) > 0 then set out to out & dbl
        set N to (N div 2)
        set dbl to (dbl & dbl)
    end repeat
    return out & dbl
end replicate

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

-- cond :: Bool -> a -> a -> a
on cond(bool, f, g)
    if bool then
        f
    else
        g
    end if
end cond
