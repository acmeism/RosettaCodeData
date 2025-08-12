Base.iterate(ll::LinkedList) = iterate(ll, ll.head)
Base.iterate(::LinkedList, st::Node) = st.data, st.next
Base.iterate(::LinkedList, ::EmptyNode) = nothing
Base.length(ll::LinkedList) = 1 + length(ll.next)
Base.length(ll::EmptyNode) = 0
Base.eltype(::LinkedList{T}) where {T} = T

lst = LinkedList{Int}()
push!(lst, 1)
push!(lst, 2)
push!(lst, 3)

for n in lst
    print(n, " ")
end
