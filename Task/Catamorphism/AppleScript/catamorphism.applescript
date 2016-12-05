-- the arguments available to the called function f(a, x, i, l) are
-- a: current accumulator value
-- x: current item in list
-- i: [ 1-based index in list ] optional
-- l: [ a reference to the list itself ] optional

-- reduce :: (a -> b -> a) -> a -> [b] -> a
on reduce(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from 1 to lng
            set v to lambda(v, item i of xs, i, xs)
        end repeat
        return v
    end tell
end reduce


-- the arguments available to the called function f(a, x, i, l) are
-- a: current accumulator value
-- x: current item in list
-- i: [ 1-based index in list ] optional
-- l: [ a reference to the list itself ] optional

-- reduceRight :: (a -> b -> a) -> a -> [b] -> a
on reduceRight(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from lng to 1 by -1
            set v to lambda(v, item i of xs, i, xs)
        end repeat
        return v
    end tell
end reduceRight


-- TEST
on run
    set lst to {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

    {reduce(sum_, 0, lst), ¬
        reduce(product_, 1, lst), ¬
        reduceRight(append_, "", lst)}

    --> {55, 3628800, "10987654321"}
end run

on sum_(a, b)
    a + b
end sum_

on product_(a, b)
    a * b
end product_

on append_(a, b)
    a & b
end append_



-- GENERIC

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
