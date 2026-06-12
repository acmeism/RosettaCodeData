module FibonacciHeaps

export FNode, FibonacciHeap, insert, extractmin, findmin, decreasekey, delete!
export Insert, MakeHeap, Minimum, ExtractMin, DecreaseKey, Delete
import Base.print

mutable struct FNode{T}
    value::T
    degree::Int
    parent::Union{FNode, Nothing}
    child::Union{FNode, Nothing}
    left::Union{FNode, Nothing}
    right::Union{FNode, Nothing}
    mark::Bool
end
FNode(data::T) where T = FNode{T}(data, 0, nothing, nothing, nothing, nothing, false)

# Get list of nodes attached to head (of a circular doubly linked list)
function aslist(head::FNode)
    nodelist, node, stop = FNode[], head, head
    flag = false
    while true
        if node == stop
            flag && break
            flag = true
        end
        push!(nodelist, node)
        node = node.right
    end
    return nodelist
end

mutable struct FibonacciHeap
    rootlist::Union{FNode, Nothing}
    minnode::Union{FNode, Nothing}
    nodecount::Int
    FibonacciHeap() = new(nothing, nothing, 0)
end
MakeHeap() = FibonacciHeap()                                             # MakeHeap()  for task

function print(io::IO, h::FibonacciHeap)
    if h.rootlist == nothing
        println("<empty heap>")
        return
    end
    function printtree(io::IO, rootnode, s::String="")
        n = rootnode
        stem= "│ "
        while n != nothing
            if n.right != rootnode
                print(io, s, "├─")
            else
                print(io, s, "└─")
                stem = "  "
            end
            if n.child == nothing
                println(io, "╴", n.value)
            else
                println(io, "┐", n.value)
                printtree(io, n.child, s * stem)
            end
            if n.right == rootnode
                break
            end
            n = n.right
        end
    end
    printtree(io, h.rootlist)
end


# return min node in O(1) time
findmin(h::FibonacciHeap) = h.minnode
Minimum(H) = findmin(H)                                                  # Minimum(H)  for task

# extract (delete) the min node from the heap in O(log n) time
function extractmin(root::FibonacciHeap)
    z = root.minnode
    if z != nothing
        if z.child != nothing
            # attach child nodes to root list
            children = aslist(z.child)
            for c in children
                merge_with_root_list(root, c)
                c.parent = nothing
            end
        end
        remove_from_root_list(root, z)
        # set new min node in heap
        if z == z.right
            root.minnode = root.rootlist = nothing
        else
            root.minnode = z.right
            consolidate(root)
        end
        root.nodecount -= 1
    end
    return z
end
ExtractMin(H) = extractmin(H)                                            # ExtractMin(H)  for task

# insert new node into the unordered root list in O(1) time
function insert(root, data)
    n = FNode(data)
    n.left = n.right = n
    merge_with_root_list(root, n)
    if root.minnode == nothing || n.value < root.minnode.value
        root.minnode = n
    end
    root.nodecount += 1
    return n
end
Insert(H, x) = insert(H, x)                                              # Insert(H, x)  for task

# modify the data of some node in the heap in O(1) time
function decreasekey(root, x, k)
    if k > x.value
        return nothing
    end
    x.value = k
    y = x.parent
    if y != nothing && x.value < y.value
        cut(root, x, y)
        cascadingcut(root, y)
    end
    if x.value < root.minnode.value
        root.minnode = x
    end
end
DecreaseKey(H, x, k) = decreasekey(H, x, k)                              # DecreaseKey(H, x, k)

# merge two fibonacci heaps in O(1) time by concatenating the root lists
# the root of the new root list becomes equal to the first list and the second
# list is simply appended to the end (then the proper min node is determined)
function merge(h1, h2)
    newh = FibonacciHeap()
    newh.rootlist, newh.minnode = h1.rootlist, h1.minnode
    # fix pointers when merging the two heaps
    last = h2.rootlist.left
    h2.rootlist.left = newh.rootlist.left
    newh.rootlist.left.right = h2.rootlist
    newh.rootlist.left = last
    newh.rootlist.left.right = newh.rootlist
    # update min node if needed
    if h2.minnode.value < newh.minnode.value
        newh.min_node = h2.minnode
    end
    # update total nodes
    newh.nodecount = h1.nodecount + h2.nodecount
    return newh
end
Union(H1, H2) = merge(H1, H2)   # NB: Union is a type in Julia          # Union(H1, H2)  for task

# if a child node becomes smaller than its parent node we
# cut this child node off and bring it up to the root list
function cut(root, x, y)
    remove_from_child_list(root, y, x)
    y.degree -= 1
    merge_with_root_list(root, x)
    x.parent = nothing
    x.mark = false
end

# cascading cut of parent node to obtain good time bounds
function cascadingcut(root, y)
    z = y.parent
    if z != nothing
        if y.mark == false
            y.mark = true
        else
            cut(root, y, z)
            cascadingcut(root, z)
        end
    end
end

# combine root nodes of equal degree to consolidate the heap
# by creating a list of unordered binomial trees
function consolidate(root)
    nodes = aslist(root.rootlist)
    len = length(nodes)
    A = fill!(Vector{Union{FNode, Nothing}}(undef, Int(round(log(root.nodecount)) * 2)), nothing)
    for x in nodes
        d = x.degree + 1
        while A[d] != nothing
            y = A[d]
            if x.value > y.value
                x, y = y, x
            end
            heaplink(root, y, x)
            A[d] = nothing
            d += 1
        end
        A[d] = x
    end
    # find new min node - no need to reconstruct new root list below
    # because root list was iteratively changing as we were moving
    # nodes around in the above loop
    for nod in A
        if nod != nothing && nod.value < root.minnode.value
            root.minnode = nod
        end
    end
end

# actual linking of one node to another in the root list
# while also updating the child linked list
function heaplink(root, y, x)
    remove_from_root_list(root, y)
    y.left = y.right = y
    merge_with_child_list(root, x, y)
    x.degree += 1
    y.parent = x
    y.mark = false
end

# merge a node with the doubly linked root list
function merge_with_root_list(root, node)
    if root.rootlist == nothing
        root.rootlist = node
    else
        node.right = root.rootlist.right
        node.left = root.rootlist
        root.rootlist.right.left = node
        root.rootlist.right = node
    end
end

# merge a node with the doubly linked child list of a root node
function merge_with_child_list(root, parent, node)
    if parent.child == nothing
        parent.child = node
    else
        node.right = parent.child.right
        node.left = parent.child
        parent.child.right.left = node
        parent.child.right = node
    end
end

# remove a node from the doubly linked root list
function remove_from_root_list(root, node)
    if node == root.rootlist
        root.rootlist = node.right
    end
    node.left.right = node.right
    node.right.left = node.left
end

# remove a node from the doubly linked child list
function remove_from_child_list(root, parent, node)
    if parent.child == parent.child.right
        parent.child = nothing
    elseif parent.child == node
        parent.child = node.right
        node.right.parent = parent
    end
    node.left.right = node.right
    node.right.left = node.left
end

function delete!(root, node)
    if (parent = node.parent) == nothing
        if node.child != nothing
            cut(root, node.child, node)
        end
        remove_from_root_list(root, node)
    else
        remove_from_child_list(root, parent, node)
    end
    if root.rootlist != nothing
        root.nodecount -= 1
        root.minnode = root.rootlist
        for n in aslist(root.rootlist)
            if n != nothing && n.value < root.minnode.value
                root.minnode = n
            end
        end
    end
end
Delete(H, x) = delete!(H, x)                                             # Delete(H, x)   for task

end  # module

using .FibonacciHeaps

const h1 = MakeHeap()
println("Made heap 1:"), print(h1)
Insert(h1, "now")
println("Inserted the word now into heap 1"), print(h1)
const h2 = MakeHeap()
println("Made another heap 2.")
const t = Insert(h2, "time")
println("Inserted the word time into heap 2:"), print(h2)
const h3 = Union(h1, h2)
println("Made heap 3, union of heap 1 and heap 2:"), print(h3)
println("The minimum of h3 is now \"$(Minimum(h3).value)\".")
const xkeys = [Insert(h3, x) for x in  ["all", "good", "men"]]
println("Inserted 3 more into h3:"), print(h3)
println("The minimum of h3 is now \"$(Minimum(h3).value)\".")
println("The extracted min from heap 3 is: ", ExtractMin(h3).value)
println("h3 is now:"), print(h3)
println("Decrease key of heap 3 value $(xkeys[3].value) with the word come:")
DecreaseKey(h3, xkeys[3], "come")
print(h3)
println("Delete node with value $(xkeys[3].value) from heap 3:")
Delete(h3, xkeys[3])
print(h3)
println("The minimum of h3 is now: ", Minimum(h3).value
