on run

    set lstRange to {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

    {{sum:reduce(summed, 0, lstRange)}, ¬
        {product:reduce(product, 1, lstRange)}}

end run

on summed(a, b)
    a + b
end summed

on product(a, b)
    a * b
end product



-- GENERIC LIBRARY FUNCTION

-- list, function, initial accumulator value
-- the arguments available to the function f(a, x, i, l) are
-- v: current accumulator value
-- x: current item in list
-- i: [ 1-based index in list ] optional
-- l: [ a reference to the list itself ] optional
on reduce(f, initialValue, xs)
    script mf
        property lambda : f
    end script

    set v to initialValue
    repeat with i from 1 to length of xs
        set v to mf's lambda(v, item i of xs, i, xs)
    end repeat
    return v
end reduce
