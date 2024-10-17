module Delegates

export Delegator, Delegate

struct Delegator{T}
    delegate::T
end

struct Delegate end

operation(x::Delegator) = thing(x.delegate)
thing(::Any) = "default implementation"
thing(::Delegate) = "delegate implementation"

end  # module Delegates
