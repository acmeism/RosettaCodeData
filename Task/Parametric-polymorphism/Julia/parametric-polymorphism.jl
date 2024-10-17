module BinaryTrees

mutable struct BinaryTree{V}
    v::V
    l::Union{BinaryTree{V}, Nothing}
    r::Union{BinaryTree{V}, Nothing}
end

BinaryTree(v) = BinaryTree(v, nothing, nothing)

map(f, bt::BinaryTree) = BinaryTree(f(bt.v), map(f, bt.l), map(f, bt.r))
map(f, bt::Nothing) = nothing

let inttree = BinaryTree(
        0,
        BinaryTree(
            1,
            BinaryTree(3),
            BinaryTree(5),
        ),
        BinaryTree(
            2,
            BinaryTree(4),
            nothing,
        ),
    )
    map(x -> 2x^2, inttree)
end

let strtree = BinaryTree(
        "hello",
        BinaryTree(
            "world!",
            BinaryTree("Julia"),
            nothing,
        ),
        BinaryTree(
            "foo",
            BinaryTree("bar"),
            BinaryTree("baz"),
        ),
    )
    map(uppercase, strtree)
end

end
