-- curry :: (Script|Handler) -> Script
on curry(f)
    script
        on |λ|(a)
            script
                on |λ|(b)
                    |λ|(a, b) of mReturn(f)
                end |λ|
            end script
        end |λ|
    end script
end curry


-- TESTS ----------------------------------------------------------------------

-- add :: Num -> Num -> Num
on add(a, b)
    a + b
end add

-- product :: Num -> Num -> Num
on product(a, b)
    a * b
end product

-- Test 1.
curry(add)

-->  «script»


-- Test 2.
curry(add)'s |λ|(2)

--> «script»


-- Test 3.
curry(add)'s |λ|(2)'s |λ|(3)

--> 5


-- Test 4.
map(curry(product)'s |λ|(7), enumFromTo(1, 10))

--> {7, 14, 21, 28, 35, 42, 49, 56, 63, 70}


-- Combined:
{curry(add), ¬
    curry(add)'s |λ|(2), ¬
    curry(add)'s |λ|(2)'s |λ|(3), ¬
    map(curry(product)'s |λ|(7), enumFromTo(1, 10))}

--> {«script», «script», 5, {7, 14, 21, 28, 35, 42, 49, 56, 63, 70}}


-- GENERIC FUNCTIONS ----------------------------------------------------------

-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if n < m then
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
