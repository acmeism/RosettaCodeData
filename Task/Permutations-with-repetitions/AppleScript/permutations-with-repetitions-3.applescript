use AppleScript version "2.4"
use framework "Foundation"
use scripting additions

-- permutesWithRepns :: [a] -> Int -> Generator [[a]]
on permutesWithRepns(xs, n)
    script
        property f : curry3(my nthPermutationWithRepn)'s |λ|(xs)'s |λ|(n)
        property limit : (length of xs) ^ n
        property i : -1
        on |λ|()
            set i to 1 + i
            if i < limit then
                return f's |λ|(i)
            else
                missing value
            end if
        end |λ|
    end script
end permutesWithRepns


-- nthPermutationWithRepn :: [a] -> Int -> Int -> [a]
on nthPermutationWithRepn(xs, intGroup, intIndex)
    set intBase to length of xs
    if intIndex < (intBase ^ intGroup) then
        set ds to baseDigits(intBase, xs, intIndex)

        -- With any 'leading zeros' required by length
        replicate(intGroup - (length of ds), item 1 of xs) & ds
    else
        missing value
    end if
end nthPermutationWithRepn


-- baseDigits :: Int -> [a] -> [a]
on baseDigits(intBase, digits, n)
    script
        on |λ|(v)
            if 0 = v then
                Nothing()
            else
                Just(Tuple(item (1 + (v mod intBase)) of digits, ¬
                    v div intBase))
            end if
        end |λ|
    end script
    unfoldr(result, n)
end baseDigits


-- TEST ------------------------------------------------------------------
on run
    set cs to "ACKR"
    set wordLength to 5
    set gen to permutesWithRepns(cs, wordLength)

    set i to 0
    set v to gen's |λ|() -- First permutation drawn from series
    set alpha to v
    set psi to alpha

    repeat while missing value is not v
        set s to concat(v)
        if "crack" = toLower(s) then
            return ("Permutation " & (i as text) & " of " & ¬
                (((length of cs) ^ wordLength) as integer) as text) & ¬
                ": " & s & linefeed & ¬
                "Found after searching from " & alpha & " thru " & psi
        else
            set i to 1 + i
            set psi to v
        end if
        set v to gen's |λ|()
    end repeat
end run


-- GENERIC ----------------------------------------------------------

-- Just :: a -> Maybe a
on Just(x)
    {type:"Maybe", Nothing:false, Just:x}
end Just

-- Nothing :: Maybe a
on Nothing()
    {type:"Maybe", Nothing:true}
end Nothing

-- Tuple (,) :: a -> b -> (a, b)
on Tuple(a, b)
    {type:"Tuple", |1|:a, |2|:b, length:2}
end Tuple

-- concat :: [[a]] -> [a]
-- concat :: [String] -> String
on concat(xs)
    set lng to length of xs
    if 0 < lng and string is class of (item 1 of xs) then
        set acc to ""
    else
        set acc to {}
    end if
    repeat with i from 1 to lng
        set acc to acc & item i of xs
    end repeat
    acc
end concat

-- curry3 :: ((a, b, c) -> d) -> a -> b -> c -> d
on curry3(f)
    script
        on |λ|(a)
            script
                on |λ|(b)
                    script
                        on |λ|(c)
                            |λ|(a, b, c) of mReturn(f)
                        end |λ|
                    end script
                end |λ|
            end script
        end |λ|
    end script
end curry3

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

-- Egyptian multiplication - progressively doubling a list, appending
-- stages of doubling to an accumulator where needed for binary
-- assembly of a target length
-- replicate :: Int -> a -> [a]
on replicate(n, a)
    set out to {}
    if n < 1 then return out
    set dbl to {a}

    repeat while (n > 1)
        if (n mod 2) > 0 then set out to out & dbl
        set n to (n div 2)
        set dbl to (dbl & dbl)
    end repeat
    return out & dbl
end replicate

-- toLower :: String -> String
on toLower(str)
    set ca to current application
    ((ca's NSString's stringWithString:(str))'s ¬
        lowercaseStringWithLocale:(ca's NSLocale's currentLocale())) as text
end toLower

-- > unfoldr (\b -> if b == 0 then Nothing else Just (b, b-1)) 10
-- > [10,9,8,7,6,5,4,3,2,1]
-- unfoldr :: (b -> Maybe (a, b)) -> b -> [a]
on unfoldr(f, v)
    set xr to Tuple(v, v) -- (value, remainder)
    set xs to {}
    tell mReturn(f)
        repeat -- Function applied to remainder.
            set mb to |λ|(|2| of xr)
            if Nothing of mb then
                exit repeat
            else -- New (value, remainder) tuple,
                set xr to Just of mb
                -- and value appended to output list.
                set end of xs to |1| of xr
            end if
        end repeat
    end tell
    return xs
end unfoldr
