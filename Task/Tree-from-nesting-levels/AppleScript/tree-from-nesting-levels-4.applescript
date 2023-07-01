----------------- FOREST FROM NEST LEVELS ----------------

-- forestFromNestLevels :: [(Int, a)] -> [Tree a]
on forestFromNestLevels(pairs)
    script go
        on |λ|(xs)
            if {} ≠ xs then
                set {n, v} to item 1 of xs

                script deeper
                    on |λ|(x)
                        n < item 1 of x
                    end |λ|
                end script
                set {descendants, rs} to ¬
                    |λ|(rest of xs) of span(deeper)

                {Node(v, |λ|(descendants))} & |λ|(rs)
            else
                {}
            end if
        end |λ|
    end script
    |λ|(pairs) of go
end forestFromNestLevels


-- nestedList :: Maybe Int -> Nest -> Nest
on nestedList(maybeLevel, xs)
    set subTree to concat(xs)
    if maybeLevel ≠ missing value then
        if {} ≠ subTree then
            {maybeLevel, subTree}
        else
            {maybeLevel}
        end if
    else
        {subTree}
    end if
end nestedList


-- treeFromSparseLevelList :: [Int] -> Tree Maybe Int
on treeFromSparseLevelList(xs)
    {missing value, ¬
        forestFromNestLevels(rooted(normalized(xs)))}
end treeFromSparseLevelList

-------------------------- TESTS -------------------------
on run
    set tests to {¬
        {}, ¬
        {1, 2, 4}, ¬
        {3, 1, 3, 1}, ¬
        {1, 2, 3, 1}, ¬
        {3, 2, 1, 3}, ¬
        {3, 3, 3, 1, 1, 3, 3, 3}}

    script translate
        on |λ|(ns)
            set tree to treeFromSparseLevelList(ns)

            set bracketNest to root(foldTree(my nestedList, tree))

            set returnTrip to foldTree(my levelList, tree)

            map(my showList, {ns, bracketNest, returnTrip})
        end |λ|
    end script

    set testResults to {{"INPUT", "NESTED", "ROUND-TRIP"}} & map(translate, tests)

    set {firstColWidth, secondColWidth} to map(widest(testResults), {fst, snd})

    script display
        on |λ|(triple)
            intercalate(" -> ", ¬
                {justifyRight(firstColWidth, space, item 1 of triple)} & ¬
                {justifyLeft(secondColWidth, space, item 2 of triple)} & ¬
                {item 3 of triple})
        end |λ|
    end script
    linefeed & unlines(map(display, testResults))
end run


-- widest :: ((a, a) -> a) ->  [String] -> Int
on widest(xs)
    script
        on |λ|(f)
            maximum(map(compose(my |length|, mReturn(f)), xs))
        end |λ|
    end script
end widest


-------------- FROM TREE BACK TO SPARSE LIST -------------

-- levelListFromNestedList :: Maybe a -> NestedList -> [a]
on levelList(maybeLevel, xs)
    if maybeLevel ≠ missing value then
        concat(maybeLevel & xs)
    else
        concat(xs)
    end if
end levelList


----- NORMALIZED TO A STRICTER GENERIC DATA STRUCTURE ----

-- normalized :: [Int] -> [(Int, Maybe Int)]
on normalized(xs)
    -- Explicit representation of implicit nodes.

    if {} ≠ xs then
        set x to item 1 of xs
        if 1 > x then
            normalized(rest of xs)
        else
            set h to {{x, x}}
            if 1 = length of xs then
                h
            else
                if 1 < ((item 2 of xs) - x) then
                    set ys to h & {{1 + x, missing value}}
                else
                    set ys to h
                end if
                ys & normalized(rest of xs)
            end if
        end if
    else
        {}
    end if
end normalized


-- rooted :: [(Int, Maybe Int)] -> [(Int, Maybe Int)]
on rooted(pairs)
    -- Path from the virtual root to the first explicit node.
    if {} ≠ pairs then
        set {n, _} to item 1 of pairs
        if 1 ≠ n then
            script go
                on |λ|(x)
                    {x, missing value}
                end |λ|
            end script
            map(go, enumFromTo(1, n - 1)) & pairs
        else
            pairs
        end if
    else
        {}
    end if
end rooted

------------------ GENERIC TREE FUNCTIONS ----------------

-- Node :: a -> [Tree a] -> Tree a
on Node(v, xs)
    -- {type:"Node", root:v, nest:xs}
    {v, xs}
end Node


-- foldTree :: (a -> [b] -> b) -> Tree a -> b
on foldTree(f, tree)
    script go
        property g : mReturn(f)
        on |λ|(tree)
            tell g to |λ|(root(tree), map(go, nest(tree)))
        end |λ|
    end script
    |λ|(tree) of go
end foldTree


-- nest :: Tree a -> [a]
on nest(oTree)
    item 2 of oTree
    -- nest of oTree
end nest


-- root :: Tree a -> a
on root(oTree)
    item 1 of oTree
    -- root of oTree
end root


---------------------- OTHER GENERIC ---------------------

-- compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
on compose(f, g)
    script
        property mf : mReturn(f)
        property mg : mReturn(g)
        on |λ|(x)
            mf's |λ|(mg's |λ|(x))
        end |λ|
    end script
end compose


-- concat :: [[a]] -> [a]
on concat(xs)
    set lng to length of xs
    set acc to {}
    repeat with i from 1 to lng
        set acc to acc & item i of xs
    end repeat
    acc
end concat


-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if m ≤ n then
        set lst to {}
        repeat with i from m to n
            set end of lst to i
        end repeat
        lst
    else
        {}
    end if
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


-- fst :: (a, b) -> a
on fst(tpl)
    if class of tpl is record then
        |1| of tpl
    else
        item 1 of tpl
    end if
end fst


-- intercalate :: String -> [String] -> String
on intercalate(delim, xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, delim}
    set s to xs as text
    set my text item delimiters to dlm
    s
end intercalate


-- justifyLeft :: Int -> Char -> String -> String
on justifyLeft(n, cFiller, strText)
    if n > length of strText then
        text 1 thru n of (strText & replicate(n, cFiller))
    else
        strText
    end if
end justifyLeft


-- justifyRight :: Int -> Char -> String -> String
on justifyRight(n, cFiller, strText)
    if n > length of strText then
        text -n thru -1 of ((replicate(n, cFiller) as text) & strText)
    else
        strText
    end if
end justifyRight


-- length :: [a] -> Int
on |length|(xs)
    set c to class of xs
    if list is c or string is c then
        length of xs
    else
        (2 ^ 29 - 1) -- (maxInt - simple proxy for non-finite)
    end if
end |length|


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


-- maximum :: Ord a => [a] -> a
on maximum(xs)
    script
        on |λ|(a, b)
            if a is missing value or b > a then
                b
            else
                a
            end if
        end |λ|
    end script

    foldl(result, missing value, xs)
end maximum


-- Egyptian multiplication - progressively doubling a list, appending
-- stages of doubling to an accumulator where needed for binary
-- assembly of a target length
-- replicate :: Int -> String -> String
on replicate(n, s)
    -- Egyptian multiplication - progressively doubling a list,
    -- appending stages of doubling to an accumulator where needed
    -- for binary assembly of a target length
    script p
        on |λ|({n})
            n ≤ 1
        end |λ|
    end script

    script f
        on |λ|({n, dbl, out})
            if (n mod 2) > 0 then
                set d to out & dbl
            else
                set d to out
            end if
            {n div 2, dbl & dbl, d}
        end |λ|
    end script

    set xs to |until|(p, f, {n, s, ""})
    item 2 of xs & item 3 of xs
end replicate


-- snd :: (a, b) -> b
on snd(tpl)
    if class of tpl is record then
        |2| of tpl
    else
        item 2 of tpl
    end if
end snd


-- showList :: [a] -> String
on showList(xs)
    "[" & intercalate(", ", map(my show, xs)) & "]"
end showList


on show(v)
    if list is class of v then
        showList(v)
    else
        v as text
    end if
end show


-- span :: (a -> Bool) -> [a] -> ([a], [a])
on span(f)
    -- The longest (possibly empty) prefix of xs
    -- that contains only elements satisfying p,
    -- tupled with the remainder of xs.
    -- span(p, xs) eq (takeWhile(p, xs), dropWhile(p, xs))
    script
        on |λ|(xs)
            set lng to length of xs
            set i to 0
            tell mReturn(f)
                repeat while lng > i and |λ|(item (1 + i) of xs)
                    set i to 1 + i
                end repeat
            end tell
            splitAt(i, xs)
        end |λ|
    end script
end span


-- splitAt :: Int -> [a] -> ([a], [a])
on splitAt(n, xs)
    if n > 0 and n < length of xs then
        if class of xs is text then
            {items 1 thru n of xs as text, ¬
                items (n + 1) thru -1 of xs as text}
        else
            {items 1 thru n of xs, items (n + 1) thru -1 of xs}
        end if
    else
        if n < 1 then
            {{}, xs}
        else
            {xs, {}}
        end if
    end if
end splitAt


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


-- until :: (a -> Bool) -> (a -> a) -> a -> a
on |until|(p, f, x)
    set v to x
    set mp to mReturn(p)
    set mf to mReturn(f)
    repeat until mp's |λ|(v)
        set v to mf's |λ|(v)
    end repeat
    v
end |until|
