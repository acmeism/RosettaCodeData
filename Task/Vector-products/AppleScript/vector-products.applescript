--------------------- VECTOR PRODUCTS ---------------------

-- dotProduct :: Num a => [a] -> [a] -> Either String a
on dotProduct(xs, ys)
    -- Dot product of two vectors of equal dimension.

    if length of xs = length of ys then
        |Right|(sum(zipWith(my mul, xs, ys)))
    else
        |Left|("Dot product not defined for vectors of differing dimension.")
    end if
end dotProduct


-- crossProduct :: Num a => (a, a, a) -> (a, a, a)
-- Either String -> (a, a, a)
on crossProduct(xs, ys)
    -- The cross product of two 3D vectors.

    if 3 ≠ length of xs or 3 ≠ length of ys then
        |Left|("Cross product is defined only for 3d vectors.")
    else
        set {x1, x2, x3} to xs
        set {y1, y2, y3} to ys
        |Right|({¬
            x2 * y3 - x3 * y2, ¬
            x3 * y1 - x1 * y3, ¬
            x1 * y2 - x2 * y1})
    end if
end crossProduct


-- scalarTriple :: Num a => (a, a, a) -> (a, a, a) -> (a, a a) ->
-- Either String -> a
on scalarTriple(q, r, s)
    -- The scalar triple product.

    script go
        on |λ|(ys)
            dotProduct(q, ys)
        end |λ|
    end script
    bindLR(crossProduct(r, s), go)
end scalarTriple


-- vectorTriple :: Num a => (a, a, a) -> (a, a, a) -> (a, a a) ->
-- Either String -> (a, a, a)
on vectorTriple(q, r, s)
    -- The vector triple product.

    script go
        on |λ|(ys)
            crossProduct(q, ys)
        end |λ|
    end script
    bindLR(crossProduct(r, s), go)
end vectorTriple


-------------------------- TEST ---------------------------
on run
    set a to {3, 4, 5}
    set b to {4, 3, 5}
    set c to {-5, -12, -13}
    set d to {3, 4, 5, 6}


    script test
        on |λ|(f)
            either(my identity, my show, ¬
                mReturn(f)'s |λ|(a, b, c, d))
        end |λ|
    end script


    tell test
        unlines({¬
            "a . b = " & |λ|(dotProduct), ¬
            "a x b = " & |λ|(crossProduct), ¬
            "a . (b x c) = " & |λ|(scalarTriple), ¬
            "a x (b x c) = " & |λ|(vectorTriple), ¬
            "a x d = " & either(my identity, my show, ¬
            dotProduct(a, d)), ¬
            "a . (b x d) = " & either(my identity, my show, ¬
            scalarTriple(a, b, d)) ¬
            })
    end tell
end run


-------------------- GENERIC FUNCTIONS --------------------

-- Left :: a -> Either a b
on |Left|(x)
    {type:"Either", |Left|:x, |Right|:missing value}
end |Left|


-- Right :: b -> Either a b
on |Right|(x)
    {type:"Either", |Left|:missing value, |Right|:x}
end |Right|


-- bindLR (>>=) :: Either a -> (a -> Either b) -> Either b
on bindLR(m, mf)
    if missing value is not |Left| of m then
        m
    else
        mReturn(mf)'s |λ|(|Right| of m)
    end if
end bindLR


-- either :: (a -> c) -> (b -> c) -> Either a b -> c
on either(lf, rf, e)
    if missing value is |Left| of e then
        tell mReturn(rf) to |λ|(|Right| of e)
    else
        tell mReturn(lf) to |λ|(|Left| of e)
    end if
end either


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


-- identity :: a -> a
on identity(x)
    -- The argument unchanged.
    x
end identity


-- intercalate :: String -> [String] -> String
on intercalate(delim, xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, delim}
    set str to xs as text
    set my text item delimiters to dlm
    str
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


-- min :: Ord a => a -> a -> a
on min(x, y)
    if y < x then
        y
    else
        x
    end if
end min


-- mul :: Num a :: a -> a -> a
on mul(x, y)
    x * y
end mul


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


-- show :: a -> String
on show(x)
    if list is class of x then
        showList(x)
    else
        str(x)
    end if
end show


-- showList :: [a] -> String
on showList(xs)
    "[" & intercalate(", ", map(my str, xs)) & "]"
end showList


-- str :: a -> String
on str(x)
    x as string
end str


-- sum :: [Number] -> Number
on sum(xs)
    script add
        on |λ|(a, b)
            a + b
        end |λ|
    end script

    foldl(add, 0, xs)
end sum


-- unlines :: [String] -> String
on unlines(xs)
    -- A single string formed by the intercalation
    -- of a list of strings with the newline character.
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, linefeed}
    set s to xs as text
    set my text item delimiters to dlm
    s
end unlines


-- zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
on zipWith(f, xs, ys)
    set lng to min(length of xs, length of ys)
    set lst to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of xs, item i of ys)
        end repeat
        return lst
    end tell
end zipWith
