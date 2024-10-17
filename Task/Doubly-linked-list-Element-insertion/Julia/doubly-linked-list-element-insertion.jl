mutable struct DLNode{T}
    value::T
    pred::Union{DLNode{T}, Nothing}
    succ::Union{DLNode{T}, Nothing}
    DLNode(v) = new{typeof(v)}(v, nothing, nothing)
end

function insertpost(prevnode, node)
    succ = prevnode.succ
    prevnode.succ = node
    node.pred = prevnode
    node.succ = succ
    if succ != nothing
        succ.pred =  node
    end
    node
end

function printfromroot(root)
    print(root.value)
    while root.succ != nothing
        root = root.succ
        print(" -> $(root.value)")
    end
    println()
end

node1 = DLNode(1)
printfromroot(node1)
node2 = DLNode(2)
node3 = DLNode(3)
insertpost(node1, node2)
printfromroot(node1)
insertpost(node1, node3)
printfromroot(node1)
