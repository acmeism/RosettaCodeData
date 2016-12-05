use framework "Foundation"

property ca : current application

-- heroniansOfSideUpTo :: Int -> [(Int, Int, Int)]
on heroniansOfSideUpTo(n)
    script sideA
        on lambda(a)
            script sideB
                on lambda(b)
                    script sideC
                        -- primitiveHeronian :: Int -> Int -> Int -> Bool
                        on primitiveHeronian(x, y, z)
                            (x ≤ y and y ≤ z) and (x + y > z) and ¬
                                gcd(gcd(x, y), z) = 1 and ¬
                                isIntegerValue(hArea(x, y, z))
                        end primitiveHeronian

                        on lambda(c)
                            if primitiveHeronian(a, b, c) then
                                [[a, b, c]]
                            else
                                []
                            end if
                        end lambda
                    end script

                    concatMap(sideC, range(b, n))
                end lambda
            end script

            concatMap(sideB, range(a, n))
        end lambda
    end script

    concatMap(sideA, range(1, n))
end heroniansOfSideUpTo



-- TEST

on run
    set n to 200

    set lstHeron to sortByKeys(map(triangleDimensions, ¬
        heroniansOfSideUpTo(n)), ¬
        {"area", "perimeter", "maxSide"})

    set lstCols to {"sides", "perimeter", "area"}
    set lstColWidths to [20, 15, 0]
    set area to 210

    script areaFilter
        -- Record -> [Record]
        on lambda(recTriangle)
            if area of recTriangle = area then
                [recTriangle]
            else
                []
            end if
        end lambda
    end script

    intercalate("

", {("Number of triangles found (with sides <= 200): " & ¬
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


-- TABLE FORMATTING

-- tabulation :: [Record] -> [String] -> String -> [Integer] -> String
on tabulation(strLegend, lstRecords, lstKeys, lstWidths)
    script heading
        on lambda(strTitle, iCol)
            set str to toCapitalized(strTitle)
            str & nreps(space, (item iCol of lstWidths) - (length of str))
        end lambda
    end script

    script lineString
        on lambda(rec)
            script fieldString
                -- fieldString :: String -> Int -> String
                on lambda(strKey, i)
                    set v to keyValue(rec, strKey)

                    if class of v is list then
                        set strData to ("(" & intercalate(", ", v) & ")")
                    else
                        set strData to v as string
                    end if

                    strData & nreps(space, (item i of (lstWidths)) - (length of strData))
                end lambda
            end script

            tab & intercalate(tab, map(fieldString, lstKeys))
        end lambda
    end script

    strLegend & ":" & linefeed & linefeed & ¬
        tab & intercalate(tab, ¬
        map(heading, lstKeys)) & linefeed & ¬
        intercalate(linefeed, map(lineString, lstRecords))
end tabulation

-- isIntegerValue :: Num -> Bool
on isIntegerValue(n)
    {real, integer} contains class of n and (n = (n as integer))
end isIntegerValue


-- sortByKeys :: [Record] -> [String] -> [Record]
on sortByKeys(lstRecords, lstKeys)
    script keyDescriptor
        on lambda(strKey)
            ca's NSSortDescriptor's ¬
                sortDescriptorWithKey:(strKey) ascending:true
        end lambda
    end script

    ((ca's NSArray's arrayWithArray:lstRecords)'s ¬
        sortedArrayUsingDescriptors:(map(keyDescriptor, lstKeys))) as list
end sortByKeys


-- keyValue :: Record -> String -> a
on keyValue(rec, strKey)
    item 1 of ((ca's NSArray's ¬
        arrayWithObject:((ca's NSDictionary's dictionaryWithDictionary:rec)'s ¬
            objectForKey:strKey)) as list)
end keyValue

-- GENERIC FUNCTIONS

-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    script append
        on lambda(a, b)
            a & b
        end lambda
    end script
    foldl(append, {}, map(f, xs))
end concatMap

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

-- range :: Int -> Int -> [Int]
on range(m, n)
    set d to 1
    if n < m then set d to -1
    set lst to {}
    repeat with i from m to n by d
        set end of lst to i
    end repeat
    return lst
end range


-- intercalate :: Text -> [Text] -> Text
on intercalate(strText, lstText)
    set {dlm, my text item delimiters} to {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    return strJoined
end intercalate

-- Text -> Text
on toCapitalized(str)
    ((ca's NSString's stringWithString:(str))'s ¬
        capitalizedStringWithLocale:(ca's NSLocale's currentLocale())) as text
end toCapitalized

-- String -> Int -> String
on nreps(s, n)
    set o to ""
    if n < 1 then return o

    repeat while (n > 1)
        if (n mod 2) > 0 then set o to o & s
        set n to (n div 2)
        set s to (s & s)
    end repeat
    return o & s
end nreps

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
