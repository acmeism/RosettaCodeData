use framework "Foundation"

-- UNDER-REPRESENTED CHARACTER IN EACH OF N COLUMNS

-- missingChar :: Record -> Character
script missingChar
    -- mean :: [Num] -> Num
    on mean(xs)
        script sum
            on lambda(a, b)
                a + b
            end lambda
        end script

        foldl(sum, 0, xs) / (length of xs)
    end mean

    -- Record -> Character
    on lambda(rec)
        set nMean to mean(allValues(rec))

        script belowMean
            on lambda(a, x, i)
                set k to toLowerCase(x)
                if a is missing value then
                    set v to keyValue(rec, k)
                    if v < nMean then
                        toUpperCase(x)
                    else
                        missing value
                    end if
                else
                    a
                end if
            end lambda
        end script

        foldl(belowMean, missing value, allKeys(rec))
    end lambda
end script

-- Count of each character type in each character column

-- colCounts :: [Character] -> Record
script colCounts
    on lambda(xs)
        script tally
            on lambda(a, x)
                set k to toLowerCase(x)
                set v to keyValue(a, k)
                if v is missing value then
                    set n to 1
                else
                    set n to v + 1
                end if
                updatedRecord(a, k, n)
            end lambda
        end script

        foldl(tally, {name:""}, xs)
    end lambda
end script

-- TEST
on run

    map(missingChar, ¬
        map(colCounts, ¬
            transpose(map(curry(splitOn)'s lambda(""), ¬
                splitOn(space, ¬
                    "ABCD CABD ACDB DACB BCDA ACBD " & ¬
                    "ADCB CDAB DABC BCAD CADB CDBA " & ¬
                    "CBAD ABDC ADBC BDCA DCBA BACD " & ¬
                    "BADC BDAC CBDA DBCA DCAB"))))) as text

    --> "DBAC"
end run


---------------------------------------------------------------------------

-- GENERIC FUNCTIONS

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

-- splitOn :: Text -> Text -> [Text]
on splitOn(strDelim, strMain)
    set {dlm, my text item delimiters} to {my text item delimiters, strDelim}
    set xs to text items of strMain
    set my text item delimiters to dlm
    return xs
end splitOn

-- ord :: Character -> Int
on ord(x)
    id of x
end ord

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


-- NSString

-- toLowerCase :: String -> String
on toLowerCase(str)
    set ca to current application
    ((ca's NSString's stringWithString:(str))'s ¬
        lowercaseStringWithLocale:(ca's NSLocale's currentLocale())) as text
end toLowerCase

-- toUpperCase :: String -> String
on toUpperCase(str)
    set ca to current application
    ((ca's NSString's stringWithString:(str))'s ¬
        uppercaseStringWithLocale:(ca's NSLocale's currentLocale())) as text
end toUpperCase


-- NSDictionary

-- allKeys :: Record -> [String]
on allKeys(rec)
    (current application's NSDictionary's dictionaryWithDictionary:rec)'s allKeys() as list
end allKeys

-- allValues :: Record -> [a]
on allValues(rec)
    (current application's NSDictionary's dictionaryWithDictionary:rec)'s allValues() as list
end allValues

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

-- updatedRecord :: Record -> String -> a -> Record
on updatedRecord(rec, strKey, varValue)
    set ca to current application
    set nsDct to (ca's NSMutableDictionary's dictionaryWithDictionary:rec)
    nsDct's setValue:varValue forKey:strKey
    item 1 of ((ca's NSArray's arrayWithObject:nsDct) as list)
end updatedRecord
