Base.start(ll::LinkedList) = ll.head
Base.done(ll::LinkedList{T}, st::AbstractNode{T}) where T = st isa EmptyNode
Base.next(ll::LinkedList{T}, st::AbstractNode{T}) where T = st.data, st.next

lst = LinkedList{Int}()
push!(lst, 1)
push!(lst, 2)
push!(lst, 3)

for n in lst
    print(n, " ")
end
