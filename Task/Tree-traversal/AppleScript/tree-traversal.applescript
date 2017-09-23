on run
    set tree to {1, {2, {4, {7}, {}}, {5}}, {3, {6, {8}, {9}}, {}}}

    -- asciiTree :: String
    set asciiTree to ¬
        unlines({¬
            "         1", ¬
            "        / \\", ¬
            "       /   \\", ¬
            "      /     \\", ¬
            "     2       3", ¬
            "    / \\     /", ¬
            "   4   5   6", ¬
            "  /       / \\", ¬
            " 7       8   9"})

    script tabulate
        on |λ|(s, xs)
            justifyLeft(14, space, s & ":") & unwords(xs)
        end |λ|
    end script

    set strResult to asciiTree & linefeed & linefeed & ¬
        unlines(zipWith(tabulate, ¬
            ["preorder", "inorder", "postorder", "level-order"], ¬
            ap([preorder, inorder, postorder, levelOrder], [tree])))

    set the clipboard to strResult
    return strResult
end run

-- TRAVERSAL FUNCTIONS --------------------------------------------------------

-- preorder :: Tree Int -> [Int]
on preorder(tree)
    set {v, l, r} to nodeParts(tree)
    if l is {} then
        set lstLeft to []
    else
        set lstLeft to preorder(l)
    end if

    if r is {} then
        set lstRight to []
    else
        set lstRight to preorder(r)
    end if
    v & lstLeft & lstRight
end preorder

-- inorder :: Tree Int -> [Int]
on inorder(tree)
    set {v, l, r} to nodeParts(tree)
    if l is {} then
        set lstLeft to []
    else
        set lstLeft to inorder(l)
    end if

    if r is {} then
        set lstRight to []
    else
        set lstRight to inorder(r)
    end if

    lstLeft & v & lstRight
end inorder

-- postorder :: Tree Int -> [Int]
on postorder(tree)
    set {v, l, r} to nodeParts(tree)
    if l is {} then
        set lstLeft to []
    else
        set lstLeft to postorder(l)
    end if

    if r is {} then
        set lstRight to []
    else
        set lstRight to postorder(r)
    end if
    lstLeft & lstRight & v
end postorder

-- levelOrder :: Tree Int -> [Int]
on levelOrder(tree)
    if length of tree > 0 then
        set {head, tail} to uncons(tree)

        -- Take any value found in the head node
        -- deferring any child nodes to the end of the tail
        -- before recursing

        if head is not {} then
            set {v, l, r} to nodeParts(head)
            v & levelOrder(tail & {l, r})
        else
            levelOrder(tail)
        end if
    else
        {}
    end if
end levelOrder

-- nodeParts :: Tree -> (Int, Tree, Tree)
on nodeParts(tree)
    if class of tree is list and length of tree = 3 then
        tree
    else
        {tree} & {{}, {}}
    end if
end nodeParts


-- GENERIC FUNCTIONS ----------------------------------------------------------

-- A list of functions applied to a list of arguments
-- (<*> | ap) :: [(a -> b)] -> [a] -> [b]
on ap(fs, xs)
    set lngFs to length of fs
    set lngXs to length of xs
    set lst to {}
    repeat with i from 1 to lngFs
        tell mReturn(contents of item i of fs)
            repeat with j from 1 to lngXs
                set end of lst to |λ|(contents of (item j of xs))
            end repeat
        end tell
    end repeat
    return lst
end ap

-- intercalate :: Text -> [Text] -> Text
on intercalate(strText, lstText)
    set {dlm, my text item delimiters} to {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    return strJoined
end intercalate

-- justifyLeft :: Int -> Char -> Text -> Text
on justifyLeft(n, cFiller, strText)
    if n > length of strText then
        text 1 thru n of (strText & replicate(n, cFiller))
    else
        strText
    end if
end justifyLeft

-- min :: Ord a => a -> a -> a
on min(x, y)
    if y < x then
        y
    else
        x
    end if
end min

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

-- uncons :: [a] -> Maybe (a, [a])
on uncons(xs)
    if length of xs > 0 then
        {item 1 of xs, rest of xs}
    else
        missing value
    end if
end uncons

-- unlines :: [String] -> String
on unlines(xs)
    intercalate(linefeed, xs)
end unlines

-- unwords :: [String] -> String
on unwords(xs)
    intercalate(space, xs)
end unwords

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
