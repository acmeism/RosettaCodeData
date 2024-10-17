function Base.insert!(ll::LinkedList{T}, index::Integer, item::T) where T
    if index == 1
        if isempty(ll)
            return push!(ll, item)
        else
            ll.head = Node{T}(item, ll.head)
        end
    else
        nd = ll.head
        while index > 2
            if nd.next isa EmptyNode
                throw(BoundsError())
            else
                nd = nd.next
                index -= 1
            end
        end
        nd.next = Node{T}(item, nd.next)
    end
    return ll
end
