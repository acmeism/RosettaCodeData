use AppleScript version "2.4"
use framework "Foundation"
use scripting additions


--------- PRIMES WITH DECIMAL DIGITS SUMMING TO 25 -------

-- primes :: [Int]
on primes()
    -- A non-finite list of primes.

    set ca to current application
    script
        property dict : ca's NSMutableDictionary's alloc's init()
        property n : 2
        on |λ|()
            set xs to dict's objectForKey:(n as string)
            repeat until missing value = xs
                repeat with x in (xs as list)
                    set m to x as number
                    set k to (n + m) as string

                    set ys to (dict's objectForKey:(k))
                    if missing value ≠ ys then
                        set zs to ys
                    else
                        set zs to ca's NSMutableArray's alloc's init()
                    end if

                    (zs's addObject:(m))

                    (dict's setValue:(zs) forKey:(k))
                    (dict's removeObjectForKey:(n as string))
                end repeat

                set n to 1 + n
                set xs to (dict's objectForKey:(n as string))
            end repeat

            set p to n
            dict's setValue:({n}) forKey:((n * n) as string)
            set n to 1 + n
            set xs to missing value
            return p
        end |λ|
    end script
end primes

-- digitSum :: Int -> Int
on digitSum(n)
    -- Sum of the decimal digits of n.

    set m to 0
    set cs to characters of (n as string)
    repeat with c in cs
        set m to m + ((id of c) - 48)
    end repeat
end digitSum

--------------------------- TEST -------------------------
on run
    script q
        on |λ|(x)
            5000 > x
        end |λ|
    end script

    script p
        on |λ|(n)
            25 = digitSum(n)
        end |λ|
    end script


    set startTime to current date
    set xs to takeWhile(q, filterGen(p, primes()))
    set elapsedSeconds to ((current date) - startTime) as string

    showList(xs)
end run

------------------------- GENERIC ------------------------

-- filterGen :: (a -> Bool) -> Gen [a] -> Gen [a]
on filterGen(p, gen)
    -- Non-finite stream of values which are
    -- drawn from gen, and satisfy p
    script
        property mp : mReturn(p)'s |λ|
        on |λ|()
            set v to gen's |λ|()
            repeat until mp(v)
                set v to gen's |λ|()
            end repeat
            return v
        end |λ|
    end script
end filterGen


-- intercalateS :: String -> [String] -> String
on intercalate(delim, xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, delim}
    set s to xs as text
    set my text item delimiters to dlm
    s
end intercalate


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


-- showList :: [a] -> String
on showList(xs)
    "[" & intercalate(",", map(my str, xs)) & "]"
end showList


-- str :: a -> String
on str(x)
    x as string
end str


-- takeWhile :: (a -> Bool) -> Gen [a] -> [a]
on takeWhile(p, xs)
    set ys to {}
    set v to |λ|() of xs
    tell mReturn(p)
        repeat while (its |λ|(v))
            set end of ys to v
            set v to xs's |λ|()
        end repeat
    end tell
    return ys
end takeWhile
