function Base.deleteat!(ll::LinkedList, index::Integer)
    if isempty(ll) throw(BoundsError()) end
    if index == 1
        ll.head = ll.head.next
    else
        nd = ll.head
        index -= 1
        while index > 1 && !isa(nd.next, EmptyNode)
            nd = nd.next
            index -= 1
        end
        if nd.next isa EmptyNode throw(BoundsError()) end
        nx = nd.next
        nd.next = nd.next.next
    end
    return ll
end
