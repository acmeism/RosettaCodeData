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


-- TESTS

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
curry(add)'s lambda(2)

--> «script»


-- Test 3.
curry(add)'s lambda(2)'s lambda(3)

--> 5


-- Test 4.
map(curry(product)'s lambda(7), range(1, 10))

--> {7, 14, 21, 28, 35, 42, 49, 56, 63, 70}


-- Combined:
{curry(add), ¬
    curry(add)'s lambda(2), ¬
    curry(add)'s lambda(2)'s lambda(3), ¬
    map(curry(product)'s lambda(7), range(1, 10))}

--> {«script», «script», 5, {7, 14, 21, 28, 35, 42, 49, 56, 63, 70}}



-- GENERIC FUNCTIONS

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
end range
