mutable struct BTree{T}
    data::T
    left::Union{BTree, Nothing}
    right::Union{BTree, Nothing}
    BTree(val::T) where T = new{T}(val, nothing, nothing)
end

function insert(tree, data)
    if data < tree.data
        if tree.left == nothing
            tree.left = BTree(data)
        else
            insert(tree.left, data)
        end
    else
        if tree.right == nothing
            tree.right = BTree(data)
        else
            insert(tree.right, data)
        end
    end
end

function sorted(tree)
    return tree == nothing ? [] :
        typeof(tree.data)[sorted(tree.left); tree.data; sorted(tree.right)]
end

function arraytotree(arr)
    tree = BTree(arr[1])
    for data in arr[2:end]
        insert(tree, data)
    end
    return tree
end

function testtreesort(arr)
    println("Unsorted: ", arr)
    tree = arraytotree(arr)
    println("Sorted: ", sorted(tree))
end

testtreesort(rand(1:99, 12))
