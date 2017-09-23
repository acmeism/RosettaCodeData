use framework "Foundation"

-- SORTING COMPOSITE STRUCTURES (BY PRIMARY AND N-ARY KEYS)

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


-- GENERIC FUNCTIONS ---------------------------------------------------------

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

-- TEST ----------------------------------------------------------------------
set xs to [¬
    {city:"Shanghai ", pop:24.2}, ¬
    {city:"Karachi ", pop:23.5}, ¬
    {city:"Beijing ", pop:21.5}, ¬
    {city:"Sao Paulo ", pop:24.2}, ¬
    {city:"Dhaka ", pop:17.0}, ¬
    {city:"Delhi ", pop:16.8}, ¬
    {city:"Lagos ", pop:16.1}]

-- Boolean true for ascending order, false for descending:

sortByComparing([{"pop", false}, {"city", true}], xs)
