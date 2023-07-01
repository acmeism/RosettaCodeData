use AppleScript version "2.4"
use framework "Foundation"
use scripting additions


on run
    set setNuggets to mcNuggetSet(100, 6, 9, 20)

    script isMcNugget
        on |λ|(x)
            setMember(x, setNuggets)
        end |λ|
    end script
    set xs to dropWhile(isMcNugget, enumFromThenTo(100, 99, 1))

    set setNuggets to missing value -- Clear ObjC pointer value
    if 0 < length of xs then
        item 1 of xs
    else
        "No unreachable quantities in this range"
    end if
end run

-- mcNuggetSet :: Int -> Int -> Int -> Int -> ObjC Set
on mcNuggetSet(n, mcx, mcy, mcz)
    set upTo to enumFromTo(0)
    script fx
        on |λ|(x)
            script fy
                on |λ|(y)
                    script fz
                        on |λ|(z)
                            set v to sum({mcx * x, mcy * y, mcz * z})
                            if 101 > v then
                                {v}
                            else
                                {}
                            end if
                        end |λ|
                    end script
                    concatMap(fz, upTo's |λ|(n div mcz))
                end |λ|
            end script
            concatMap(fy, upTo's |λ|(n div mcy))
        end |λ|
    end script
    setFromList(concatMap(fx, upTo's |λ|(n div mcx)))
end mcNuggetSet


-- GENERIC FUNCTIONS ----------------------------------------------------

-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set lng to length of xs
    set acc to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set acc to acc & |λ|(item i of xs, i, xs)
        end repeat
    end tell
    return acc
end concatMap


-- drop :: Int -> [a] -> [a]
-- drop :: Int -> String -> String
on drop(n, xs)
    set c to class of xs
    if c is not script then
        if c is not string then
            if n < length of xs then
                items (1 + n) thru -1 of xs
            else
                {}
            end if
        else
            if n < length of xs then
                text (1 + n) thru -1 of xs
            else
                ""
            end if
        end if
    else
        take(n, xs) -- consumed
        return xs
    end if
end drop

-- dropWhile :: (a -> Bool) -> [a] -> [a]
-- dropWhile :: (Char -> Bool) -> String -> String
on dropWhile(p, xs)
    set lng to length of xs
    set i to 1
    tell mReturn(p)
        repeat while i ≤ lng and |λ|(item i of xs)
            set i to i + 1
        end repeat
    end tell
    drop(i - 1, xs)
end dropWhile

-- enumFromThenTo :: Int -> Int -> Int -> [Int]
on enumFromThenTo(x1, x2, y)
    set xs to {}
    repeat with i from x1 to y by (x2 - x1)
        set end of xs to i
    end repeat
    return xs
end enumFromThenTo

-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m)
    script
        on |λ|(n)
            if m ≤ n then
                set lst to {}
                repeat with i from m to n
                    set end of lst to i
                end repeat
                return lst
            else
                return {}
            end if
        end |λ|
    end script
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

-- Lift 2nd class handler function into 1st class script wrapper
-- mReturn :: First-class m => (a -> b) -> m (a -> b)
on mReturn(f)
    if class of f is script then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn

-- sum :: [Num] -> Num
on sum(xs)
    script add
        on |λ|(a, b)
            a + b
        end |λ|
    end script

    foldl(add, 0, xs)
end sum

-- NB All names of NSMutableSets should be set to *missing value*
-- before the script exits.
-- ( scpt files can not be saved if they contain ObjC pointer values )
-- setFromList :: Ord a => [a] -> Set a
on setFromList(xs)
    set ca to current application
    ca's NSMutableSet's ¬
        setWithArray:(ca's NSArray's arrayWithArray:(xs))
end setFromList

-- setMember :: Ord a => a -> Set a -> Bool
on setMember(x, objcSet)
    missing value is not (objcSet's member:(x))
end setMember
