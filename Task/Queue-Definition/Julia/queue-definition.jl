struct Queue{T}
    a::Array{T,1}
end

Queue() = Queue(Any[])
Queue(a::DataType) = Queue(a[])
Queue(a) = Queue(typeof(a)[])

Base.isempty(q::Queue) = isempty(q.a)

function Base.pop!(q::Queue{T}) where {T}
    !isempty(q) || error("queue must be non-empty")
    pop!(q.a)
end

function Base.push!(q::Queue{T}, x::T) where {T}
    pushfirst!(q.a, x)
    return q
end

function Base.push!(q::Queue{Any}, x::T) where {T}
    pushfirst!(q.a, x)
    return q
end
