import Base.pop!, Base.push!, Base.length, Base.*
using LinearAlgebra, Random

struct ProjectorStack{P <: AbstractVector}
    vs::Vector{P}
end
Base.push!(p::ProjectorStack, v) = (push!(p.vs, v); p)
Base.pop!(p::ProjectorStack) = (pop!(p.vs); p)
Base.:*(p::ProjectorStack, v) = (s = zero(v); for vi in p.vs s += vi * dot(vi, v) end; s)

"""
    GärtnerBoundary

See the passage regarding M_B in Section 4 of Gärtner's paper.
"""
mutable struct GärtnerBoundary{P<:AbstractVector, F<:AbstractFloat}
    centers::Vector{P}
    square_radii::Vector{F}
    # projection onto of affine space spanned by points
    # shifted such that first point becomes origin
    projector::ProjectorStack{P}
    empty_center::P # center of nsphere spanned by empty boundary
end

function GärtnerBoundary(pts)
    P = eltype(pts)
    F = eltype(P)
    projector, centers, square_radii = ProjectorStack(P[]), P[], F[]
    empty_center = F(NaN) * first(pts)
    GärtnerBoundary(centers, square_radii, projector, empty_center)
end

function push_if_stable!(b::GärtnerBoundary, pt)
    if isempty(b)
        push!(b.square_radii, zero(eltype(pt)))
        push!(b.centers, pt)
        dim = length(pt)
        return true
    end
    q0, center = first(b.centers), b.centers[end]
    C, r2  = center - q0, b.square_radii[end]
    Qm, M = pt - q0, b.projector
    Qm_bar = M*Qm
    residue, e = Qm - Qm_bar, sqdist(Qm, C) - r2
    z, tol = 2*sqnorm(residue), eps(eltype(pt)) * max(r2, one(r2))
    isstable = abs(z) > tol
    if isstable
        center_new  = center + (e/z) * residue
        r2new = r2 + (e^2)/(2z)
        push!(b.projector, residue / norm(residue))
        push!(b.centers, center_new)
        push!(b.square_radii, r2new)
    end
    return isstable
end

function Base.pop!(b::GärtnerBoundary)
    n = length(b)
    pop!(b.centers)
    pop!(b.square_radii)
    if n >= 2
        pop!(b.projector)
    end
    return b
end

struct NSphere{P,F}
    center::P
    sqradius::F
end

function isinside(pt, nsphere::NSphere; atol=0, rtol=0)
    r2, R2 = sqdist(pt, center(nsphere)), sqradius(nsphere)
    return r2 <= R2 || isapprox(r2, R2;atol=atol^2,rtol=rtol^2)
end
allinside(pts, nsphere; kw...) = all(pt -> isinside(pt, nsphere; kw...), pts)

function move_to_front!(pts, i)
    pt = pts[i]
    for j in eachindex(pts)
        pts[j], pt = pt, pts[j]
        j == i && break
    end
    pts
end

prefix(pts, i) = view(pts, 1:i)
Base.length(b::GärtnerBoundary) = length(b.centers)
Base.isempty(b::GärtnerBoundary) = length(b) == 0
center(b::NSphere) = b.center
radius(b::NSphere) = sqrt(b.sqradius)
sqradius(b::NSphere) = b.sqradius
dist(p1,p2) = norm(p1-p2)
sqdist(p1::AbstractVector, p2::AbstractVector) = sqnorm(p1-p2)
sqnorm(p) = sum(abs2,p)
ismaxlength(b::GärtnerBoundary) = length(b) == length(b.empty_center) + 1

function NSphere(b::GärtnerBoundary)
    return isempty(b) ? NSphere(b.empty_center, 0.0) :
        NSphere(b.centers[end], b.square_radii[end])
end

function welzl!(pts, bdry)
    bdry_len, support_count, nsphere = length(bdry), 0, NSphere(bdry)
    ismaxlength(bdry) && return nsphere, 0
    for i in eachindex(pts)
        pt = pts[i]
        if !isinside(pt, nsphere)
            pts_i = prefix(pts, i-1)
            isstable = push_if_stable!(bdry, pt)
            if isstable
                nsphere, s = welzl!(pts_i, bdry)
                pop!(bdry)
                move_to_front!(pts, i)
                support_count = s + 1
            end
        end
    end
    return nsphere, support_count
end

function find_max_excess(nsphere, pts, k1)
    T = eltype(first(pts))
    e_max, k_max = T(-Inf), k1 -1
    for k in k1:length(pts)
        pt = pts[k]
        e = sqdist(pt, center(nsphere)) - sqradius(nsphere)
        if  e > e_max
            e_max = e
            k_max = k
        end
    end
    return e_max, k_max
end

function welzl(points, maxiterations=2000)
    pts = deepcopy(points)
    bdry, t = GärtnerBoundary(pts), 1
    nsphere, s = welzl!(prefix(pts, t), bdry)
    for i in 1:maxiterations
        e, k = find_max_excess(nsphere, pts, t + 1)
        P = eltype(pts)
        F = eltype(P)
        e <= eps(F) && break
        pt = pts[k]
        push_if_stable!(bdry, pt)
        nsphere_new, s_new = welzl!(prefix(pts, s), bdry)
        pop!(bdry)
        move_to_front!(pts, k)
        nsphere = nsphere_new
        t, s = s + 1, s_new + 1
    end
    return nsphere
end

function testwelzl()
    testdata =[
        [[0.0, 0.0], [0.0, 1.0], [1.0, 0.0]],
        [[5.0, -2.0], [-3.0, -2.0], [-2.0, 5.0], [1.0, 6.0], [0.0, 2.0]],
        [[2.0, 4.0, -1.0], [1.0, 5.0, -3.0], [8.0, -4.0, 1.0], [3.0, 9.0, -5.0]],
        [randn(5) for _ in 1:8]
    ]
    for test in testdata
        nsphere = welzl(test)
        println("For points: ", test)
        println("    Center is at: ", nsphere.center)
        println("    Radius is: ", radius(nsphere), "\n")
    end
end

testwelzl()
