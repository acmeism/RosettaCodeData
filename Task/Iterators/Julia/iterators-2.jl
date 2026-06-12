struct LinkedList{T}
    value::T
    next::Union{LinkedList{T},Nothing}
end

Base.iterate(list::LinkedList, node::LinkedList = list) = (node.value, node.next)
Base.iterate(::LinkedList, ::Nothing) = nothing
