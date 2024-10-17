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

first(nd) = (while nd.pred != nothing nd = nd.prev end; nd)
last(nd) = (while nd.succ != nothing nd = nd.succ end; nd)

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
insertpost(node1, node2)
insertpost(node2, node3)
print("From beginning to end: "); printconnected(node1)
print("From end to beginning: "); printconnected(node1, fromtail = true)
