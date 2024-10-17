abstract type AbstractNode{T} end

struct EmptyNode{T} <: AbstractNode{T} end
mutable struct Node{T} <: AbstractNode{T}
    value::T
    pred::AbstractNode{T}
    succ::AbstractNode{T}
end
