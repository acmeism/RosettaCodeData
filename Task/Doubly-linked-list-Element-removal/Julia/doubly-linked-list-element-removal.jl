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
    return node
end

function delete(node)
    succ = node.succ
    pred = node.pred
    succ != nothing && (succ.pred = pred)
    pred != nothing && (pred.succ = succ)
    return node
end

first(nd) = (while nd.pred != nothing nd = nd.prev end; nd)
last(nd) = (while nd.succ != nothing nd = nd.succ end; nd)

function atindex(nd, idx)
    nd = first(nd)
    while idx > 1 && nd != nothing
        nd = nd.succ
        idx -= 1
    end
    return nd
end

function printconnected(nd; fromtail = false)
    if fromtail
        nd = last(nd)
        print(nd.value)
        while nd.pred != nothing
            nd = nd.pred
            print(" -> $(nd.value)")
        end
    else
        nd = first(nd)
        print(nd.value)
        while nd.succ != nothing
            nd = nd.succ
            print(" -> $(nd.value)")
        end
    end
    println()
end

node1 = DLNode(1)
node2 = DLNode(2)
node3 = DLNode(3)
node4 = DLNode(4)

insertpost(node1, node2)
insertpost(node2, node3)
insertpost(node3, node4)

print("From beginning to end: "); printconnected(node1)
delete(atindex(node1, 3))
println("Deleting third node yields: "); printconnected(node1)
delete(node2)
println("Then deleting node2 yields: "); printconnected(node1)
