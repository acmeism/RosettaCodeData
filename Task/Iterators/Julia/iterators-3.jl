Base.length(list::LinkedList) = isnothing(list.next) ? 1 : 1 + length(list.next)
Base.eltype(::LinkedList{T}) where {T} = T
