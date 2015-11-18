type Queue{T}
    a::Array{T,1}
end

Queue() = Queue(Any[])
Queue(a::DataType) = Queue(a[])
Queue(a) = Queue(typeof(a)[])

Base.isempty(q::Queue) = isempty(q.a)

function Base.pop!{T}(q::Queue{T})
    !isempty(q) || error("queue must be non-empty")
    pop!(q.a)
end

function Base.push!{T}(q::Queue{T}, x::T)
    unshift!(q.a, x)
    return q
end

function Base.push!{T}(q::Queue{Any}, x::T)
    unshift!(q.a, x)
    return q
end
