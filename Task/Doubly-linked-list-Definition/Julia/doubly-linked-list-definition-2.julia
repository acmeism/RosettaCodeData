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

function insertpre(postnode, node)
    pred = postnode.pred
    postnode.pred = node
    node.succ = postnode
    node.pred = pred
    if pred != nothing
        pred.succ = node
    end
    node
end

function delete(nd)
    if nd != nothing
        pred = nd.pred
        succ = nd.succ
        if pred != nothing pred.succ = succ end
        if succ != nothing succ.pred = pred end
    end
    nothing
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
node4 = DLNode(4)
insertpost(node1, node2)
insertpre(node2, node4)
insertpost(node2, node3)
println("First value is ", first(node1).value, " and last value is ", last(node1).value)
print("From beginning to end: "); printconnected(node1)
delete(node4)
print("From end to beginning post deletion: "); printconnected(node1, fromtail = true)
