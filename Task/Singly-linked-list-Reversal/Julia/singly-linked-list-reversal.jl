abstract type LinkedList{T} end

Base.eltype(::Type{<:LinkedList{T}}) where T = T

mutable struct Nil{T} <: LinkedList{T} end

mutable struct Cons{T} <: LinkedList{T}
    head::T
    tail::LinkedList{T}
end

cons(h, t::LinkedList{T}) where {T} = Cons{T}(h, t)

nil(T) = Nil{T}()
nil() = nil(Any)

head(x::Cons) = x.head
tail(x::Cons) = x.tail

function Base.show(io::IO, l::LinkedList{T}) where T
    if isa(l,Nil)
        if T === Any
            print(io, "nil()")
        else
            print(io, "nil(", T, ")")
        end
    else
        print(io, "list(")
        show(io, head(l))
        for t in tail(l)
            print(io, ", ")
            show(io, t)
        end
        print(io, ")")
    end
end

function list(elts...)
    l = nil(Base.promote_typeof(elts...))
    for i=length(elts):-1:1
        l = cons(elts[i],l)
    end
    return l
end

Base.iterate(l::LinkedList, ::Nil) = nothing
function Base.iterate(l::LinkedList, state::Cons = l)
    state.head, state.tail
end

function Base.reverse(l::LinkedList{T}) where T
    l2 = nil(T)
    for h in l
        l2 = cons(h, l2)
    end
    return l2
end

llist = list(1, 2, 3, 4, 5)
revlist = reverse(llist)
@show llist revlist
