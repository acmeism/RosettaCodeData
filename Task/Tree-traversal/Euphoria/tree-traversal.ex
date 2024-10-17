constant VALUE = 1, LEFT = 2, RIGHT = 3

constant tree = {1,
                    {2,
                        {4,
                            {7, 0, 0},
                            0},
                        {5, 0, 0}},
                    {3,
                        {6,
                            {8, 0, 0},
                            {9, 0, 0}},
                        0}}

procedure preorder(object tree)
    if sequence(tree) then
        printf(1,"%d ",{tree[VALUE]})
        preorder(tree[LEFT])
        preorder(tree[RIGHT])
    end if
end procedure

procedure inorder(object tree)
    if sequence(tree) then
        inorder(tree[LEFT])
        printf(1,"%d ",{tree[VALUE]})
        inorder(tree[RIGHT])
    end if
end procedure

procedure postorder(object tree)
    if sequence(tree) then
        postorder(tree[LEFT])
        postorder(tree[RIGHT])
        printf(1,"%d ",{tree[VALUE]})
    end if
end procedure

procedure lo(object tree, sequence more)
    if sequence(tree) then
        more &= {tree[LEFT],tree[RIGHT]}
        printf(1,"%d ",{tree[VALUE]})
    end if
    if length(more) > 0 then
        lo(more[1],more[2..$])
    end if
end procedure

procedure level_order(object tree)
    lo(tree,{})
end procedure

puts(1,"preorder:    ")
preorder(tree)
puts(1,'\n')

puts(1,"inorder:     ")
inorder(tree)
puts(1,'\n')

puts(1,"postorder:   ")
postorder(tree)
puts(1,'\n')

puts(1,"level-order: ")
level_order(tree)
puts(1,'\n')
