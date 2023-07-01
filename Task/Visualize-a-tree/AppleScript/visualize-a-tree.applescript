-- Vertically centered textual tree using UTF8 monospaced
-- box-drawing characters, with options for compacting
-- and pruning.

--               ┌── Gamma
--       ┌─ Beta ┼── Delta
--       │       └ Epsilon
-- Alpha ┼─ Zeta ───── Eta
--       │       ┌─── Iota
--       └ Theta ┼── Kappa
--               └─ Lambda

-- TESTS --------------------------------------------------
on run
    set tree to Node(1, ¬
        {Node(2, ¬
            {Node(4, {Node(7, {})}), ¬
                Node(5, {})}), ¬
            Node(3, ¬
                {Node(6, ¬
                    {Node(8, {}), Node(9, {})})})})

    set tree2 to Node("Alpha", ¬
        {Node("Beta", ¬
            {Node("Gamma", {}), ¬
                Node("Delta", {}), ¬
                Node("Epsilon", {})}), ¬
            Node("Zeta", {Node("Eta", {})}), ¬
            Node("Theta", ¬
                {Node("Iota", {}), Node("Kappa", {}), ¬
                    Node("Lambda", {})})})

    set strTrees to unlines({"(NB – view in mono-spaced font)\n\n", ¬
        "Compacted (not all parents vertically centered):\n", ¬
        drawTree2(true, false, tree), ¬
        "\nFully expanded and vertically centered:\n", ¬
        drawTree2(false, false, tree2), ¬
        "\nVertically centered, with nodeless lines pruned out:\n", ¬
        drawTree2(false, true, tree2)})
    set the clipboard to strTrees
    strTrees
end run


-- drawTree2 :: Bool -> Bool -> Tree String -> String
on drawTree2(blnCompressed, blnPruned, tree)
    -- Tree design and algorithm inspired by the Haskell snippet at:
    -- https://doisinkidney.com/snippets/drawing-trees.html
    script measured
        on |λ|(t)
            script go
                on |λ|(x)
                    set s to " " & x & " "
                    Tuple(length of s, s)
                end |λ|
            end script
            fmapTree(go, t)
        end |λ|
    end script
    set measuredTree to |λ|(tree) of measured

    script levelMax
        on |λ|(a, level)
            a & maximum(map(my fst, level))
        end |λ|
    end script
    set levelWidths to foldl(levelMax, {}, ¬
        init(levels(measuredTree)))

    -- Lefts, Mid, Rights
    script lmrFromStrings
        on |λ|(xs)
            set {ls, rs} to items 2 thru -2 of ¬
                (splitAt((length of xs) div 2, xs) as list)
            Tuple3(ls, item 1 of rs, rest of rs)
        end |λ|
    end script

    script stringsFromLMR
        on |λ|(lmr)
            script add
                on |λ|(a, x)
                    a & x
                end |λ|
            end script
            foldl(add, {}, items 2 thru -2 of (lmr as list))
        end |λ|
    end script

    script fghOverLMR
        on |λ|(f, g, h)
            script
                property mg : mReturn(g)
                on |λ|(lmr)
                    set {ls, m, rs} to items 2 thru -2 of (lmr as list)
                    Tuple3(map(f, ls), |λ|(m) of mg, map(h, rs))
                end |λ|
            end script
        end |λ|
    end script

    script lmrBuild
        on leftPad(n)
            script
                on |λ|(s)
                    replicateString(n, space) & s
                end |λ|
            end script
        end leftPad

        -- lmrBuild main
        on |λ|(w, f)
            script
                property mf : mReturn(f)
                on |λ|(wsTree)
                    set xs to nest of wsTree
                    set lng to length of xs
                    set {nChars, x} to items 2 thru -2 of ¬
                        ((root of wsTree) as list)
                    set _x to replicateString(w - nChars, "─") & x

                    -- LEAF NODE ------------------------------------
                    if 0 = lng then
                        Tuple3({}, _x, {})

                    else if 1 = lng then
                        -- NODE WITH SINGLE CHILD ---------------------
                        set indented to leftPad(1 + w)
                        script lineLinked
                            on |λ|(z)
                                _x & "─" & z
                            end |λ|
                        end script
                        |λ|(|λ|(item 1 of xs) of mf) of ¬
                            (|λ|(indented, lineLinked, indented) of ¬
                                fghOverLMR)
                    else
                        -- NODE WITH CHILDREN -------------------------
                        script treeFix
                            on cFix(x)
                                script
                                    on |λ|(xs)
                                        x & xs
                                    end |λ|
                                end script
                            end cFix

                            on |λ|(l, m, r)
                                compose(stringsFromLMR, ¬
                                    |λ|(cFix(l), cFix(m), cFix(r)) of ¬
                                    fghOverLMR)
                            end |λ|
                        end script

                        script linked
                            on |λ|(s)
                                set c to text 1 of s
                                set t to tail(s)
                                if "┌" = c then
                                    _x & "┬" & t
                                else if "│" = c then
                                    _x & "┤" & t
                                else if "├" = c then
                                    _x & "┼" & t
                                else
                                    _x & "┴" & t
                                end if
                            end |λ|
                        end script

                        set indented to leftPad(w)
                        set lmrs to map(f, xs)
                        if blnCompressed then
                            set sep to {}
                        else
                            set sep to {"│"}
                        end if

                        tell lmrFromStrings
                            set tupleLMR to |λ|(intercalate(sep, ¬
                                {|λ|(item 1 of lmrs) of ¬
                                    (|λ|(" ", "┌", "│") of treeFix)} & ¬
                                map(|λ|("│", "├", "│") of treeFix, ¬
                                    init(tail(lmrs))) & ¬
                                {|λ|(item -1 of lmrs) of ¬
                                    (|λ|("│", "└", " ") of treeFix)}))
                        end tell

                        |λ|(tupleLMR) of ¬
                            (|λ|(indented, linked, indented) of fghOverLMR)
                    end if
                end |λ|
            end script
        end |λ|
    end script

    set treeLines to |λ|(|λ|(measuredTree) of ¬
        foldr(lmrBuild, 0, levelWidths)) of stringsFromLMR
    if blnPruned then
        script notEmpty
            on |λ|(s)
                script isData
                    on |λ|(c)
                        "│ " does not contain c
                    end |λ|
                end script
                any(isData, characters of s)
            end |λ|
        end script
        set xs to filter(notEmpty, treeLines)
    else
        set xs to treeLines
    end if
    unlines(xs)
end drawTree2


-- GENERIC ------------------------------------------------

-- Node :: a -> [Tree a] -> Tree a
on Node(v, xs)
    {type:"Node", root:v, nest:xs}
end Node

-- Tuple (,) :: a -> b -> (a, b)
on Tuple(a, b)
    -- Constructor for a pair of values, possibly of two different types.
    {type:"Tuple", |1|:a, |2|:b, length:2}
end Tuple

-- Tuple3 (,,) :: a -> b -> c -> (a, b, c)
on Tuple3(x, y, z)
    {type:"Tuple3", |1|:x, |2|:y, |3|:z, length:3}
end Tuple3

-- Applied to a predicate and a list,
-- |any| returns true if at least one element of the
-- list satisfies the predicate.
-- any :: (a -> Bool) -> [a] -> Bool
on any(f, xs)
    tell mReturn(f)
        set lng to length of xs
        repeat with i from 1 to lng
            if |λ|(item i of xs) then return true
        end repeat
        false
    end tell
end any

-- compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
on compose(f, g)
    script
        property mf : mReturn(f)
        property mg : mReturn(g)
        on |λ|(x)
            |λ|(|λ|(x) of mg) of mf
        end |λ|
    end script
end compose

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

-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set lng to length of xs
    set acc to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set acc to acc & (|λ|(item i of xs, i, xs))
        end repeat
    end tell
    return acc
end concatMap

-- filter :: (a -> Bool) -> [a] -> [a]
on filter(f, xs)
    tell mReturn(f)
        set lst to {}
        set lng to length of xs
        repeat with i from 1 to lng
            set v to item i of xs
            if |λ|(v, i, xs) then set end of lst to v
        end repeat
        return lst
    end tell
end filter

-- fmapTree :: (a -> b) -> Tree a -> Tree b
on fmapTree(f, tree)
    script go
        property g : |λ| of mReturn(f)
        on |λ|(x)
            set xs to nest of x
            if xs ≠ {} then
                set ys to map(go, xs)
            else
                set ys to xs
            end if
            Node(g(root of x), ys)
        end |λ|
    end script
    |λ|(tree) of go
end fmapTree

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

-- foldr :: (a -> b -> b) -> b -> [a] -> b
on foldr(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from lng to 1 by -1
            set v to |λ|(item i of xs, v, i, xs)
        end repeat
        return v
    end tell
end foldr

-- fst :: (a, b) -> a
on fst(tpl)
    if class of tpl is record then
        |1| of tpl
    else
        item 1 of tpl
    end if
end fst

-- identity :: a -> a
on identity(x)
    -- The argument unchanged.
    x
end identity

-- init :: [a] -> [a]
-- init :: [String] -> [String]
on init(xs)
    set blnString to class of xs = string
    set lng to length of xs

    if lng > 1 then
        if blnString then
            text 1 thru -2 of xs
        else
            items 1 thru -2 of xs
        end if
    else if lng > 0 then
        if blnString then
            ""
        else
            {}
        end if
    else
        missing value
    end if
end init

-- intercalate :: [a] -> [[a]] -> [a]
-- intercalate :: String -> [String] -> String
on intercalate(sep, xs)
    concat(intersperse(sep, xs))
end intercalate

-- intersperse(0, [1,2,3]) -> [1, 0, 2, 0, 3]
-- intersperse :: a -> [a] -> [a]
-- intersperse :: Char -> String -> String
on intersperse(sep, xs)
    set lng to length of xs
    if lng > 1 then
        set acc to {item 1 of xs}
        repeat with i from 2 to lng
            set acc to acc & {sep, item i of xs}
        end repeat
        if class of xs is string then
            concat(acc)
        else
            acc
        end if
    else
        xs
    end if
end intersperse

-- isNull :: [a] -> Bool
-- isNull :: String -> Bool
on isNull(xs)
    if class of xs is string then
        "" = xs
    else
        {} = xs
    end if
end isNull

-- iterateUntil :: (a -> Bool) -> (a -> a) -> a -> [a]
on iterateUntil(p, f, x)
    script
        property mp : mReturn(p)'s |λ|
        property mf : mReturn(f)'s |λ|
        property lst : {x}
        on |λ|(v)
            repeat until mp(v)
                set v to mf(v)
                set end of lst to v
            end repeat
            return lst
        end |λ|
    end script
    |λ|(x) of result
end iterateUntil

-- levels :: Tree a -> [[a]]
on levels(tree)
    script nextLayer
        on |λ|(xs)
            script
                on |λ|(x)
                    nest of x
                end |λ|
            end script
            concatMap(result, xs)
        end |λ|
    end script

    script roots
        on |λ|(xs)
            script
                on |λ|(x)
                    root of x
                end |λ|
            end script
            map(result, xs)
        end |λ|
    end script

    map(roots, iterateUntil(my isNull, nextLayer, {tree}))
end levels

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

-- replicateString :: Int -> String -> String
on replicateString(n, s)
    set out to ""
    if n < 1 then return out
    set dbl to s

    repeat while (n > 1)
        if (n mod 2) > 0 then set out to out & dbl
        set n to (n div 2)
        set dbl to (dbl & dbl)
    end repeat
    return out & dbl
end replicateString

-- snd :: (a, b) -> b
on snd(tpl)
    if class of tpl is record then
        |2| of tpl
    else
        item 2 of tpl
    end if
end snd

-- splitAt :: Int -> [a] -> ([a], [a])
on splitAt(n, xs)
    if n > 0 and n < length of xs then
        if class of xs is text then
            Tuple(items 1 thru n of xs as text, items (n + 1) thru -1 of xs as text)
        else
            Tuple(items 1 thru n of xs, items (n + 1) thru -1 of xs)
        end if
    else
        if n < 1 then
            Tuple({}, xs)
        else
            Tuple(xs, {})
        end if
    end if
end splitAt

-- tail :: [a] -> [a]
on tail(xs)
    set blnText to text is class of xs
    if blnText then
        set unit to ""
    else
        set unit to {}
    end if
    set lng to length of xs
    if 1 > lng then
        missing value
    else if 2 > lng then
        unit
    else
        if blnText then
            text 2 thru -1 of xs
        else
            rest of xs
        end if
    end if
end tail

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
