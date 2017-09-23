type Node{T}
    data::T
    next::Nullable{Node{T}}

    function Node(data::T)
        n = new()
        n.data = data
        # To mark the end of the list we use the Nullable{T}() function .
        n.next = Nullable{Node{T}}()
        n
    end
end

# convenience. Let use write Node(10) or Node(10.0) instead of Node{Int64}(10), Node{Float64}(10.0)
function Node(data)
    return Node{typeof(data)}(data)
end

islast(n::Node) = (isnull(n.next))

function append{T}(n::Node{T}, data::T)
    tmp = Node(data)
    if !islast(n)
        tmp.next = n.next
    end
    n.next = tmp
end
