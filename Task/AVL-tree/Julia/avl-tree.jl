module AVLTrees

import Base.print
export AVLNode, AVLTree, insert, deletekey, deletevalue, findnodebykey, findnodebyvalue, allnodes

@enum Direction LEFT RIGHT
avlhash(x) = Int32(hash(x) & 0xfffffff)
const MIDHASH = Int32(div(0xfffffff, 2))

mutable struct AVLNode{T}
    value::T
    key::Int32
    balance::Int32
    left::Union{AVLNode, Nothing}
    right::Union{AVLNode, Nothing}
    parent::Union{AVLNode, Nothing}
end
AVLNode(v::T, b, l, r, p) where T <: Real = AVLNode(v, avlhash(v), Int32(b), l, r, p)
AVLNode(v::T, h, b::Int64, l, r, p) where T <: Real = AVLNode(v, h, Int32(b), l, r, p)
AVLNode(v::T) where T <: Real = AVLNode(v, avlhash(v), Int32(0), nothing, nothing, nothing)

AVLTree(typ::Type) = AVLNode(typ(0), MIDHASH, Int32(0), nothing, nothing, nothing)
const MaybeAVL = Union{AVLNode, Nothing}

height(node::MaybeAVL) = (node == nothing) ? 0 : 1 + max(height(node.right), height(node.left))

function insert(node, value)
    if node == nothing
        node = AVLNode(value)
        return true
    end
    key, n, parent::MaybeAVL = avlhash(value), node, nothing
    while true
        if n.key == key
            return false
        end
        parent = n
        ngreater = n.key > key
        n = ngreater ? n.left : n.right
        if n == nothing
            if ngreater
                parent.left = AVLNode(value, key, 0, nothing, nothing, parent)
            else
                parent.right = AVLNode(value, key, 0, nothing, nothing, parent)
            end
            rebalance(parent)
            break
        end
    end
    return true
end

function deletekey(node, delkey)
    node == nothing && return nothing
    n, parent = MaybeAVL(node), MaybeAVL(node)
    delnode, child = MaybeAVL(nothing), MaybeAVL(node)
    while child != nothing
        parent, n = n, child
        child = delkey >= n.key ? n.right : n.left
        if delkey == n.key
            delnode = n
        end
    end
    if delnode != nothing
        delnode.key = n.key
        delnode.value = n.value
        child = (n.left != nothing) ? n.left : n.right
        if node.key == delkey
            root = child
        else
            if parent.left == n
                parent.left = child
            else
                parent.right = child
            end
            rebalance(parent)
        end
    end
end

deletevalue(node, val) = deletekey(node, avlhash(val))

function rebalance(node::MaybeAVL)
    node == nothing && return nothing
    setbalance(node)
    if node.balance < -1
        if height(node.left.left) >= height(node.left.right)
            node = rotate(node, RIGHT)
        else
            node = rotatetwice(node, LEFT, RIGHT)
        end
    elseif node.balance > 1
        if node.right != nothing && height(node.right.right) >= height(node.right.left)
            node = rotate(node, LEFT)
        else
            node = rotatetwice(node, RIGHT, LEFT)
        end
    end
    if node != nothing && node.parent != nothing
        rebalance(node.parent)
    end
end

function rotate(a, direction)
    (a == nothing || a.parent == nothing) && return nothing
    b = direction == LEFT ? a.right : a.left
    b == nothing && return
    b.parent = a.parent
    if direction == LEFT
        a.right = b.left
    else
        a.left  = b.right
    end
    if a.right != nothing
        a.right.parent = a
    end
    if direction == LEFT
        b.left = a
    else
        b.right = a
    end
    a.parent = b
    if b.parent != nothing
        if b.parent.right == a
            b.parent.right = b
        else
            b.parent.left = b
        end
    end
    setbalance([a, b])
    return b
end

function rotatetwice(n, dir1, dir2)
    n.left = rotate(n.left, dir1)
    rotate(n, dir2)
end

setbalance(n::AVLNode) = begin n.balance = height(n.right) - height(n.left) end
setbalance(n::Nothing) = 0
setbalance(nodes::Vector) = for n in nodes setbalance(n) end

function findnodebykey(node, key)
    result::MaybeAVL = node == nothing ? nothing : node.key == key ? node :
        node.left != nothing && (n = findbykey(n, key) != nothing) ? n :
        node.right != nothing ? findbykey(node.right, key) : nothing
    return result
end
findnodebyvalue(node, val) = findnodebykey(node, avlhash(v))

function allnodes(node)
    result = AVLNode[]
    if node != nothing
        append!(result, allnodes(node.left))
        if node.key != MIDHASH
            push!(result, node)
        end
        append!(result, node.right)
    end
    return result
end

function Base.print(io::IO, n::MaybeAVL)
    if n != nothing
        n.left != nothing && print(io, n.left)
        print(io, n.key == MIDHASH ? "<ROOT> " : "<$(n.key):$(n.value):$(n.balance)> ")
        n.right != nothing && print(io, n.right)
    end
end

end # module

using .AVLTrees

const tree = AVLTree(Int)

println("Inserting 10 values.")
foreach(x -> insert(tree, x), rand(collect(1:80), 10))
println("Printing tree after insertion: ")
println(tree)
