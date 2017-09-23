use framework "Foundation"

-- SORTING LISTS OF ATOMIC (NON-RECORD) DATA WITH A CUSTOM SORT FUNCTION

-- In sortBy, f is a function from () to a tuple of two parts:
-- 1. a function from any value to a record derived from (and containing) that value
--  The base value should be present in the record under the key 'value'
--  additional derivative keys (and optionally the 'value' key) should be included in 2:
-- 2. a list of (record key, boolean) tuples, in the order of sort comparison,
--    where the value *true* selects ascending order for the paired key
--    and the value *false* selects descending order for that key

-- sortBy :: (() -> ((a -> Record), [(String, Bool)])) -> [a] -> [a]
on sortBy(f, xs)
    set {fn, keyBools} to mReturn(f)'s |λ|()
    script unWrap
        on |λ|(x)
            value of x
        end |λ|
    end script
    map(unWrap, sortByComparing(keyBools, map(fn, xs)))
end sortBy

-- SORTING APPLESCRIPT RECORDS BY PRIMARY AND N-ARY SORT KEYS

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
on run
    set xs to ["Shanghai", "Karachi", "Beijing", "Sao Paulo", "Dhaka", "Delhi", "Lagos"]

    -- Custom comparator:

    -- Returns a lifting function and a sequence of {key, bool} pairs

    -- Strings in order of descending length,
    -- and ascending lexicographic order
    script lengthDownAZup
        on |λ|()
            script
                on |λ|(x)
                    {value:x, n:length of x}
                end |λ|
            end script
            {result, {{"n", false}, {"value", true}}}
        end |λ|
    end script

    sortBy(lengthDownAZup, xs)
end run
