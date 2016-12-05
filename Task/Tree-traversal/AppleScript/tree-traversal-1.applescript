on run
    set tree to {1, {2, {4, {7}, {}}, {5}}, {3, {6, {8}, {9}}, {}}}

    return {|pre-order|:¬
        traverse("pre-order", tree), |in-order|:¬
        traverse("in-order", tree), |post-order|:¬
        traverse("post-order", tree), |level-order|:¬
        traverse("level-order", tree)}

end run

-- traverse :: String -> Tree -> [Int]
on traverse(strOrderName, tree)
    if strOrderName does not start with "level" then
        set {v, l, r} to nodeParts(tree)

        if l is {} then
            set lstLeft to []
        else
            set lstLeft to traverse(strOrderName, l)
        end if

        if r is {} then
            set lstRight to []
        else
            set lstRight to traverse(strOrderName, r)
        end if

        -- PRE-ORDER
        if strOrderName begins with "pre" then
            v & lstLeft & lstRight

            -- IN-ORDER
        else if strOrderName begins with "in" then
            lstLeft & v & lstRight

            -- POST-ORDER
        else if strOrderName begins with "post" then
            lstLeft & lstRight & v

        end if
    else
        -- LEVEL-ORDER
        levelOrder({tree})
    end if
end traverse


-- levelOrder :: [Tree] -> [Int]
on levelOrder(lstTree)
    if length of lstTree > 0 then
        set {head, tail} to uncons(lstTree)

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


-- GENERIC

-- uncons :: [a] -> Maybe (a, [a])
on uncons(xs)
    if length of xs > 0 then
        {item 1 of xs, rest of xs}
    else
        missing value
    end if
end uncons
