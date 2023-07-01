const Thunk = Function # can't define other than as a generalized Function

struct CIS{T}
    head :: T
    tail :: Thunk # produces the next CIS{T}
    CIS{T}(head :: T, tail :: Thunk) where T = new(head, tail)
end
Base.eltype(::Type{CIS{T}}) where T = T
Base.IteratorSize(::Type{CIS{T}}) where T = Base.SizeUnknown()
function Base.iterate(C::CIS{T}, state = C) :: Tuple{T, CIS{T}} where T
    state.head, state.tail()
end

function treefoldingprimes()::CIS{Int}
    function merge(xs::CIS{Int}, ys::CIS{Int})::CIS{Int}
        x = xs.head; y = ys.head
        if x < y CIS{Int}(x, () -> merge(xs.tail(), ys))
        elseif y < x CIS{Int}(y, () -> merge(xs, ys.tail()))
        else CIS{Int}(x, () -> merge(xs.tail(), ys.tail())) end
    end
    function pmultiples(p::Int)::CIS{Int}
        adv :: Int = p + p
        next(c::Int)::CIS{Int} = CIS{Int}(c, () -> next(c + adv)); next(p * p)
    end
    function allmultiples(ps::CIS{Int})::CIS{CIS{Int}}
        CIS{CIS{Int}}(pmultiples(ps.head), () -> allmultiples(ps.tail()))
    end
    function pairs(css :: CIS{CIS{Int}})::CIS{CIS{Int}}
        nextcss = css.tail()
        CIS{CIS{Int}}(merge(css.head, nextcss.head), ()->pairs(nextcss.tail()))
    end
    function composites(css :: CIS{CIS{Int}})::CIS{Int}
        CIS{Int}(css.head.head, ()-> merge(css.head.tail(),
                                            css.tail() |> pairs |> composites))
    end
    function minusat(n::Int, cs::CIS{Int})::CIS{Int}
        if n < cs.head CIS{Int}(n, () -> minusat(n + 2, cs))
        else minusat(n + 2, cs.tail()) end
    end
    oddprimes()::CIS{Int} = CIS{Int}(3, () -> minusat(5, oddprimes()
                                        |> allmultiples |> composites))
    CIS{Int}(2, () -> oddprimes())
end
