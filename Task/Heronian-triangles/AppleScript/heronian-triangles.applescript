use framework "Foundation"

-- HERONIAN TRIANGLES --------------------------------------------------------

-- heroniansOfSideUpTo :: Int -> [(Int, Int, Int)]
on heroniansOfSideUpTo(n)
    script sideA
        on |λ|(a)
            script sideB
                on |λ|(b)
                    script sideC
                        -- primitiveHeronian :: Int -> Int -> Int -> Bool
                        on primitiveHeronian(x, y, z)
                            (x ≤ y and y ≤ z) and (x + y > z) and ¬
                                gcd(gcd(x, y), z) = 1 and ¬
                                isIntegerValue(hArea(x, y, z))
                        end primitiveHeronian

                        on |λ|(c)
                            if primitiveHeronian(a, b, c) then
                                {{a, b, c}}
                            else
                                {}
                            end if
                        end |λ|
                    end script

                    concatMap(sideC, enumFromTo(b, n))
                end |λ|
            end script

            concatMap(sideB, enumFromTo(a, n))
        end |λ|
    end script

    concatMap(sideA, enumFromTo(1, n))
end heroniansOfSideUpTo


-- TEST ----------------------------------------------------------------------
on run
    set n to 200

    set lstHeron to ¬
        sortByComparing({{"area", true}, {"perimeter", true}, {"maxSide", true}}, ¬
            map(triangleDimensions, heroniansOfSideUpTo(n)))

    set lstCols to {"sides", "perimeter", "area"}
    set lstColWidths to {20, 15, 0}
    set area to 210

    script areaFilter
        -- Record -> [Record]
        on |λ|(recTriangle)
            if area of recTriangle = area then
                {recTriangle}
            else
                {}
            end if
        end |λ|
    end script

    intercalate("\n \n", {("Number of triangles found (with sides <= 200): " & ¬
        length of lstHeron as string), ¬
        ¬
            tabulation("First 10, ordered by area, perimeter, longest side", ¬
                items 1 thru 10 of lstHeron, lstCols, lstColWidths), ¬
        ¬
            tabulation("Area = 210", ¬
                concatMap(areaFilter, lstHeron), lstCols, lstColWidths)})
end run

-- triangleDimensions :: (Int, Int, Int) ->
--       {sides: (Int, Int, Int),  area: Int, perimeter: Int, maxSize: Int}
on triangleDimensions(lstSides)
    set {x, y, z} to lstSides
    {sides:[x, y, z], area:hArea(x, y, z) as integer, perimeter:x + y + z, maxSide:z}
end triangleDimensions

-- hArea :: Int -> Int -> Int -> Num
on hArea(x, y, z)
    set s to (x + y + z) / 2
    set a to s * (s - x) * (s - y) * (s - z)

    if a > 0 then
        a ^ 0.5
    else
        0
    end if
end hArea

-- gcd :: Int -> Int -> Int
on gcd(m, n)
    if n = 0 then
        m
    else
        gcd(n, m mod n)
    end if
end gcd


-- TABULATION ----------------------------------------------------------------

-- tabulation :: [Record] -> [String] -> String -> [Integer] -> String
on tabulation(strLegend, lstRecords, lstKeys, lstWidths)
    script heading
        on |λ|(strTitle, iCol)
            set str to toTitle(strTitle)
            str & replicate((item iCol of lstWidths) - (length of str), space)
        end |λ|
    end script

    script lineString
        on |λ|(rec)
            script fieldString
                -- fieldString :: String -> Int -> String
                on |λ|(strKey, i)
                    set v to keyValue(strKey, rec)

                    if class of v is list then
                        set strData to ("(" & intercalate(", ", v) & ")")
                    else
                        set strData to v as string
                    end if

                    strData & replicate(space, (item i of (lstWidths)) - (length of strData))
                end |λ|
            end script

            tab & intercalate(tab, map(fieldString, lstKeys))
        end |λ|
    end script

    strLegend & ":" & linefeed & linefeed & ¬
        tab & intercalate(tab, ¬
        map(heading, lstKeys)) & linefeed & ¬
        intercalate(linefeed, map(lineString, lstRecords))
end tabulation

-- GENERIC FUNCTIONS ---------------------------------------------------------

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

-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    concat(map(f, xs))
end concatMap

-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if m > n then
        set d to -1
    else
        set d to 1
    end if
    set lst to {}
    repeat with i from m to n by d
        set end of lst to i
    end repeat
    return lst
end enumFromTo

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

-- isIntegerValue :: Num -> Bool
on isIntegerValue(n)
    {real, integer} contains class of n and (n = (n as integer))
end isIntegerValue

-- keyValue :: String -> Record -> Maybe String
on keyValue(strKey, rec)
    set ca to current application
    set v to (ca's NSDictionary's dictionaryWithDictionary:rec)'s objectForKey:strKey
    if v is not missing value then
        item 1 of ((ca's NSArray's arrayWithObject:v) as list)
    else
        missing value
    end if
end keyValue

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

-- List of {strKey, blnAscending} pairs -> list of records -> sorted list of records

-- sortByComparing :: [(String, Bool)] -> [Records] -> [Records]
on sortByComparing(keyDirections, xs)
    set ca to current application

    script recDict
        on |λ|(x)
            ca's NSDictionary's dictionaryWithDictionary:x
        end |λ|
    end script
    set dcts to map(recDict, xs)

    script asDescriptor
        on |λ|(kd)
            set {k, d} to kd
            ca's NSSortDescriptor's sortDescriptorWithKey:k ascending:d selector:dcts
        end |λ|
    end script

    ((ca's NSArray's arrayWithArray:dcts)'s ¬
        sortedArrayUsingDescriptors:map(asDescriptor, keyDirections)) as list
end sortByComparing

-- toTitle :: String -> String
on toTitle(str)
    set ca to current application
    ((ca's NSString's stringWithString:(str))'s ¬
        capitalizedStringWithLocale:(ca's NSLocale's currentLocale())) as text
end toTitle
