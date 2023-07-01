use AppleScript version "2.4"
use framework "Foundation"
use scripting additions


-- isCusip :: String -> Bool
on isCusip(s)
    set cs to "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ*&#"
    set ns to mapMaybe(elemIndex(cs), s)

    script go
        on |λ|(f, x)
            set fx to apply(f, x)
            (fx div 10) + (fx mod 10)
        end |λ|
    end script

    9 = length of ns and item -1 of ns = (10 - (sum(zipWith(go, ¬
        cycle({my identity, my double}), ¬
        take(8, ns))) mod 10)) mod 10
end isCusip


-------------------------- TEST ---------------------------
on run
    script test
        on |λ|(s)
            s & " -> " & isCusip(s)
        end |λ|
    end script

    unlines(map(test, ¬
        {"037833100", "17275R102", "38259P508", ¬
            "594918104", "68389X106", "68389X105"}))
end run

-- 037833100 -> true
-- 17275R102 -> true
-- 38259P508 -> true
-- 594918104 -> true
-- 68389X106 -> false
-- 68389X105 -> true


-------------------- GENERIC FUNCTIONS --------------------

-- Just :: a -> Maybe a
on Just(x)
    -- Constructor for an inhabited Maybe (option type) value.
    -- Wrapper containing the result of a computation.
    {type:"Maybe", Nothing:false, Just:x}
end Just


-- Nothing :: Maybe a
on Nothing()
    -- Constructor for an empty Maybe (option type) value.
    -- Empty wrapper returned where a computation is not possible.
    {type:"Maybe", Nothing:true}
end Nothing


-- Tuple (,) :: a -> b -> (a, b)
on Tuple(a, b)
    -- Constructor for a pair of values, possibly of two different types.
    {type:"Tuple", |1|:a, |2|:b, length:2}
end Tuple


-- apply ($) :: (a -> b) -> a -> b
on apply(f, x)
    -- The value of f(x)
    mReturn(f)'s |λ|(x)
end apply


-- cycle :: [a] -> Generator [a]
on cycle(xs)
    script
        property lng : 1 + (length of xs)
        property i : missing value
        on |λ|()
            if missing value is i then
                set i to 1
            else
                set nxt to (1 + i) mod lng
                if 0 = ((1 + i) mod lng) then
                    set i to 1
                else
                    set i to nxt
                end if
            end if
            return item i of xs
        end |λ|
    end script
end cycle


-- double :: Num -> Num
on double(x)
    2 * x
end double


-- elemIndex :: Eq a => [a] -> a -> Maybe Int
on elemIndex(xs)
    script
        on |λ|(x)
            set lng to length of xs
            repeat with i from 1 to lng
                if x = (item i of xs) then return Just(i - 1)
            end repeat
            return Nothing()
        end |λ|
    end script
end elemIndex


-- identity :: a -> a
on identity(x)
    -- The argument unchanged.
    x
end identity


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


-- length :: [a] -> Int
on |length|(xs)
    set c to class of xs
    if list is c or string is c then
        length of xs
    else
        (2 ^ 29 - 1) -- (maxInt - simple proxy for non-finite)
    end if
end |length|


-- map :: (a -> b) -> [a] -> [b]
on map(f, xs)
    -- The list obtained by applying f
    -- to each element of xs.
    tell mReturn(f)
        set lng to length of xs
        set lst to {}
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of xs, i, xs)
        end repeat
        return lst
    end tell
end map


-- The mapMaybe function is a version of map which can throw out
-- elements. In particular, the functional argument returns
-- something of type Maybe b. If this is Nothing, no element is
-- added on to the result list. If it just Just b, then b is
-- included in the result list.
-- mapMaybe :: (a -> Maybe b) -> [a] -> [b]
on mapMaybe(mf, xs)
    script
        property g : mReturn(mf)
        on |λ|(a, x)
            set mb to g's |λ|(x)
            if Nothing of mb then
                a
            else
                a & (Just of mb)
            end if
        end |λ|
    end script
    foldl(result, {}, xs)
end mapMaybe


-- min :: Ord a => a -> a -> a
on min(x, y)
    if y < x then
        y
    else
        x
    end if
end min


-- mReturn :: First-class m => (a -> b) -> m (a -> b)
on mReturn(f)
    -- 2nd class handler function lifted into 1st class script wrapper.
    if script is class of f then
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


-- take :: Int -> [a] -> [a]
-- take :: Int -> String -> String
on take(n, xs)
    set c to class of xs
    if list is c then
        if 0 < n then
            items 1 thru min(n, length of xs) of xs
        else
            {}
        end if
    else if string is c then
        if 0 < n then
            text 1 thru min(n, length of xs) of xs
        else
            ""
        end if
    else if script is c then
        set ys to {}
        repeat with i from 1 to n
            set v to |λ|() of xs
            if missing value is v then
                return ys
            else
                set end of ys to v
            end if
        end repeat
        return ys
    else
        missing value
    end if
end take


-- unlines :: [String] -> String
on unlines(xs)
    -- A single string formed by the intercalation
    -- of a list of strings with the newline character.
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, linefeed}
    set str to xs as text
    set my text item delimiters to dlm
    str
end unlines


-- zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
on zipWith(f, xs, ys)
    set lng to min(|length|(xs), |length|(ys))
    if 1 > lng then return {}
    set xs_ to take(lng, xs) -- Allow for non-finite
    set ys_ to take(lng, ys) -- generators like cycle etc
    set lst to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of xs_, item i of ys_)
        end repeat
        return lst
    end tell
end zipWith
