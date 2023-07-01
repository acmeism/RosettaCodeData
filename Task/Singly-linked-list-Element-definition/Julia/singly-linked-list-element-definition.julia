abstract type AbstractNode{T} end

struct EmptyNode{T} <: AbstractNode{T} end
mutable struct Node{T} <: AbstractNode{T}
    data::T
    next::AbstractNode{T}
end
Node{T}(x) where T = Node{T}(x::T, EmptyNode{T}())

mutable struct LinkedList{T}
    head::AbstractNode{T}
end
LinkedList{T}() where T = LinkedList{T}(EmptyNode{T}())
LinkedList() = LinkedList{Any}()

Base.isempty(ll::LinkedList) = ll.head isa EmptyNode
function lastnode(ll::LinkedList)
    if isempty(ll) throw(BoundsError()) end
    nd = ll.head
    while !(nd.next isa EmptyNode)
        nd = nd.next
    end
    return nd
end

function Base.push!(ll::LinkedList{T}, x::T) where T
    nd = Node{T}(x)
    if isempty(ll)
        ll.head = nd
    else
        tail = lastnode(ll)
        tail.next = nd
    end
    return ll
end
function Base.pop!(ll::LinkedList{T}) where T
    if isempty(ll)
        throw(ArgumentError("list must be non-empty"))
    elseif ll.head.next isa EmptyNode
        nd = ll.head
        ll.head = EmptyNode{T}()
    else
        nx = ll.head
        while !isa(nx.next.next, EmptyNode)
            nx = nx.next
        end
        nd = nx.next
        nx.next = EmptyNode{T}()
    end
    return nd.data
end

lst = LinkedList{Int}()
push!(lst, 1)
push!(lst, 2)
push!(lst, 3)
pop!(lst) # 3
pop!(lst) # 2
pop!(lst) # 1
