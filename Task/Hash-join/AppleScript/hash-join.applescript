use framework "Foundation" -- Yosemite onwards, for record-handling functions

-- hashJoin :: [Record] -> [Record] -> String -> [Record]
on hashJoin(tblA, tblB, strJoin)
    set {jA, jB} to splitOn("=", strJoin)

    script instanceOfjB
        on lambda(a, x)
            set strID to keyValue(x, jB)

            set maybeInstances to keyValue(a, strID)
            if maybeInstances is not missing value then
                updatedRecord(a, strID, maybeInstances & {x})
            else
                updatedRecord(a, strID, [x])
            end if
        end lambda
    end script

    set M to foldl(instanceOfjB, {name:"multiMap"}, tblB)

    script joins
        on lambda(a, x)
            set matches to keyValue(M, keyValue(x, jA))
            if matches is not missing value then
                script concat
                    on lambda(row)
                        x & row
                    end lambda
                end script

                a & map(concat, matches)
            else
                a
            end if
        end lambda
    end script

    foldl(joins, {}, tblA)
end hashJoin

-- TEST
on run
    set lstA to [¬
        {age:27, |name|:"Jonah"}, ¬
        {age:18, |name|:"Alan"}, ¬
        {age:28, |name|:"Glory"}, ¬
        {age:18, |name|:"Popeye"}, ¬
        {age:28, |name|:"Alan"}]

    set lstB to [¬
        {|character|:"Jonah", nemesis:"Whales"}, ¬
        {|character|:"Jonah", nemesis:"Spiders"}, ¬
        {|character|:"Alan", nemesis:"Ghosts"}, ¬
        {|character|:"Alan", nemesis:"Zombies"}, ¬
        {|character|:"Glory", nemesis:"Buffy"}, ¬
        {|character|:"Bob", nemesis:"foo"}]

    hashJoin(lstA, lstB, "name=character")
end run


-- RECORD PRIMITIVES

-- keyValue :: String -> Record -> Maybe a
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


-- GENERIC PRIMITIVES

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

-- splitOn :: Text -> Text -> [Text]
on splitOn(strDelim, strMain)
    set {dlm, my text item delimiters} to {my text item delimiters, strDelim}
    set lstParts to text items of strMain
    set my text item delimiters to dlm
    return lstParts
end splitOn

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
