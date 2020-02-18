-- foldTree :: (a -> [b] -> b) -> Tree a -> b
on foldTree(f)
    script
        on |λ|(tree)
            script go
                property g : mReturn(f)'s |λ|
                on |λ|(oNode)
                    g(root of oNode, |λ|(nest of oNode) ¬
                        of map(go))
                end |λ|
            end script
            |λ|(tree) of go
        end |λ|
    end script
end foldTree

-- preorder :: a -> [[a]] -> [a]
on preorder(x, xs)
    {x} & concat(xs)
end preorder

-- inorder :: a -> [[a]] -> [a]
on inorder(x, xs)
    if {} ≠ xs then
        item 1 of xs & x & concat(rest of xs)
    else
        {x}
    end if
end inorder

-- postorder :: a -> [[a]] -> [a]
on postorder(x, xs)
    concat(xs) & {x}
end postorder

-- levelOrder :: Tree a -> [a]
on levelOrder(tree)
    script notNull
        on |λ|(x)
            0 < length of x
        end |λ|
    end script

    script concatMapNest
        on |λ|(xs)
            |λ|(xs) of concatMap(my nest)
        end |λ|
    end script

    |λ|(takeWhile(notNull, iterate(concatMapNest, {tree}))) ¬
        of concatMap(map(my root))
end levelOrder


---------------------------TEST----------------------------
on run
    set tree to Node(1, ¬
        {Node(2, ¬
            {Node(4, {Node(7, {})}), ¬
                Node(5, {})}), ¬
            Node(3, ¬
                {Node(6, {Node(8, {}), ¬
                    Node(9, {})})})})


    -- Output of AppleScript code at Rosetta Code task
    -- 'Visualize a Tree':
    set strTree to unlines({¬
        "       ┌ 4 ─ 7", ¬
        "   ┌ 2 ┤", ¬
        "   │   └ 5", ¬
        " 1 ┤", ¬
        "   │       ┌ 8", ¬
        "   └ 3 ─ 6 ┤", ¬
        "           └ 9"})

    script tabulate
        on |λ|(s, xs)
            justifyRight(14, space, s & ": ") & unwords(xs)
        end |λ|
    end script

    set strResult to strTree & linefeed & unlines(zipWith(tabulate, ¬
        ["preorder", "inorder", "postorder", "level-order"], ¬
        apList([¬
            foldTree(preorder), ¬
            foldTree(inorder), ¬
            foldTree(postorder), ¬
            levelOrder], [tree])))

    set the clipboard to strResult
    return strResult
end run


--------------------------GENERIC--------------------------

-- Node :: a -> [Tree a] -> Tree a
on Node(v, xs)
    {type:"Node", root:v, nest:xs}
end Node


-- e.g. [(*2),(/2), sqrt] <*> [1,2,3]
-- -->  ap([dbl, hlf, root], [1, 2, 3])
-- -->  [2,4,6,0.5,1,1.5,1,1.4142135623730951,1.7320508075688772]

-- Each member of a list of functions applied to
-- each of a list of arguments, deriving a list of new values
-- apList (<*>) :: [(a -> b)] -> [a] -> [b]
on apList(fs, xs)
    set lst to {}
    repeat with f in fs
        tell mReturn(contents of f)
            repeat with x in xs
                set end of lst to |λ|(contents of x)
            end repeat
        end tell
    end repeat
    return lst
end apList


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
on concatMap(f)
    script
        on |λ|(xs)
            set lng to length of xs
            set acc to {}
            tell mReturn(f)
                repeat with i from 1 to lng
                    set acc to acc & (|λ|(item i of xs, i, xs))
                end repeat
            end tell
            return acc
        end |λ|
    end script
end concatMap

-- iterate :: (a -> a) -> a -> Gen [a]
on iterate(f, x)
    script
        property v : missing value
        property g : mReturn(f)'s |λ|
        on |λ|()
            if missing value is v then
                set v to x
            else
                set v to g(v)
            end if
            return v
        end |λ|
    end script
end iterate


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
on map(f)
    -- The list obtained by applying f
    -- to each element of xs.
    script
        on |λ|(xs)
            tell mReturn(f)
                set lng to length of xs
                set lst to {}
                repeat with i from 1 to lng
                    set end of lst to |λ|(item i of xs, i, xs)
                end repeat
                return lst
            end tell
        end |λ|
    end script
end map

-- min :: Ord a => a -> a -> a
on min(x, y)
    if y < x then
        y
    else
        x
    end if
end min

-- nest :: Tree a -> [a]
on nest(oTree)
    nest of oTree
end nest


-- Egyptian multiplication - progressively doubling a list, appending
-- stages of doubling to an accumulator where needed for binary
-- assembly of a target length
-- replicate :: Int -> a -> [a]
on replicate(n, a)
    set out to {}
    if 1 > n then return out
    set dbl to {a}

    repeat while (1 < n)
        if 0 < (n mod 2) then set out to out & dbl
        set n to (n div 2)
        set dbl to (dbl & dbl)
    end repeat
    return out & dbl
end replicate

-- root :: Tree a -> a
on root(oTree)
    root of oTree
end root


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

-- takeWhile :: (a -> Bool) -> Gen [a] -> [a]
on takeWhile(p, xs)
    set ys to {}
    set v to |λ|() of xs
    tell mReturn(p)
        repeat while (|λ|(v))
            set end of ys to v
            set v to xs's |λ|()
        end repeat
    end tell
    return ys
end takeWhile

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

-- unwords :: [String] -> String
on unwords(xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, space}
    set s to xs as text
    set my text item delimiters to dlm
    return s
end unwords

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
