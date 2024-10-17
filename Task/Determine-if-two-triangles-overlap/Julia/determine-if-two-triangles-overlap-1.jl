module Triangles

using LinearAlgebra

export AntiClockwise, Both, StrictCheck, MildCheck

abstract type Widing end
struct AntiClockwise <: Widing end
struct Both          <: Widing end

function _check_triangle_winding(t, widing::AntiClockwise)
    trisq = fill!(Matrix{eltype(t)}(undef, 3, 3), 1)
    trisq[:, 1:2] .= t
    det(trisq) < 0 && throw(ArgumentError("triangle has wrong winding direction"))
    return trisq
end

function _check_triangle_winding(t, widing::Both)
    trisq = fill!(Matrix{eltype(t)}(undef, 3, 3), 1)
    trisq[:, 1:2] .= t
    if det(trisq) < 0
        tmp = trisq[2, :]
        trisq[2, :] .= trisq[1, :]
        trisq[1, :] .= tmp
    end
    return trisq
end

abstract type OnBoundaryCheck end
struct StrictCheck <: OnBoundaryCheck end
struct MildCheck   <: OnBoundaryCheck end

_checkedge(::StrictCheck, x, ϵ) = det(x) < ϵ
_checkedge(::MildCheck, x, ϵ)   = det(x) ≤ ϵ

function overlap(T₁, T₂, onboundary::OnBoundaryCheck=MildCheck(),; ϵ=0.0, widing::Widing=AntiClockwise())
    # Trangles must be expressed anti-clockwise
    T₁ = _check_triangle_winding(T₁, widing)
    T₂ = _check_triangle_winding(T₂, widing)

    edge = similar(T₁)
    for (A, B) in ((T₁, T₂), (T₂, T₁)), i in 1:3
        circshift!(edge, A, (i, 0))
        @views if all(_checkedge(onboundary, vcat(edge[1:2, :], B[r, :]'), ϵ) for r in 1:3)
            return false
        end
    end

    return true
end

end  # module Triangles
