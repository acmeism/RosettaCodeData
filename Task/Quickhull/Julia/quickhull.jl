# QuickHull3D.jl

using Printf

const MAXN = 2500
const EPS  = 1e-8

# Tell Julia we intend to extend these Base methods
import Base: -, ==

# 3D vector with an ID
mutable struct Vect
    x::Float64; y::Float64; z::Float64; id::Int
end

# Subtract two Vect’s
function -(a::Vect, b::Vect)
    Vect(a.x - b.x, a.y - b.y, a.z - b.z, 0)
end

# Equality of two Vect’s (approximate)
function ==(a::Vect, b::Vect)
    abs(a.x-b.x)<EPS && abs(a.y-b.y)<EPS && abs(a.z-b.z)<EPS
end

# Cross, dot, magnitude
function cross(a::Vect, b::Vect)
    Vect(
        a.y*b.z - a.z*b.y,
        a.z*b.x - a.x*b.z,
        a.x*b.y - a.y*b.x,
        0
    )
end

dot(a::Vect, b::Vect) = a.x*b.x + a.y*b.y + a.z*b.z
mag(a::Vect) = sqrt(a.x^2 + a.y^2 + a.z^2)

# Line and Plane types
struct Line
    u::Vect; v::Vect
end

struct Plane
    u::Vect; v::Vect; w::Vect
end

normal(p::Plane) = cross(p.v - p.u, p.w - p.u)
vecAt(p::Plane, i::Int) = (i==1 ? p.u : i==2 ? p.v : p.w)
vecId(p::Plane, i::Int) = vecAt(p, i).id

# Floating‐point comparison
gtr(a,b) = a - b > EPS

# Distances
dist_point_plane(v::Vect, p::Plane) = dot(v - p.u, normal(p)) / mag(normal(p))
dist_point_line(v::Vect, l::Line) = begin
    d = mag(v - l.u)
    d>0 ? mag(cross(l.v - l.u, v - l.u)) / mag(l.v - l.u) : 0.0
end
dist_point_point(a::Vect, b::Vect) = mag(a - b)
isabove(v::Vect, p::Plane) = gtr(dot(v - p.u, normal(p)), 0)

# Facet and Edge
mutable struct Facet
    n::NTuple{3,Int}      # neighbor facet indices
    id::Int               # facet ID
    vistime::Int          # timestamp for DFS
    isdel::Bool           # deleted?
    p::Plane              # supporting plane
end
Facet() = Facet((0,0,0),0,0,false,Plane(Vect(0,0,0,0),Vect(0,0,0,0),Vect(0,0,0,0)))

mutable struct Edge
    netid::Int
    facetid::Int
end
Edge() = Edge(0,0)

mutable struct ConvexHulls3d
    index::Int
    surfacearea::Float64
end
ConvexHulls3d(idx::Int) = ConvexHulls3d(idx, 0.0)

# Globals
FAC      = Facet[]
pts      = Vector{Vect}[]
TIME     = 0
e        = [ Edge() for i in 1:2, j in 1:MAXN ]
vistime  = zeros(Int, MAXN)
queue    = Int[]
resfnew  = Int[]
resfdel  = Int[]
respt    = Vect[]

# Initialize
function preConvexHulls()
    push!(pts, Vect[])    # reserve index 1
    push!(FAC, Facet())   # dummy facet[1]
end

# DFS for surface area
function dfsArea(h::ConvexHulls3d, fidx::Int)
    f = FAC[fidx]
    if f.vistime == TIME return end
    f.vistime = TIME
    nrm = normal(f.p)
    h.surfacearea += mag(nrm)/2
    for i in 1:3
        dfsArea(h, f.n[i])
    end
end

function getSurfaceArea(h::ConvexHulls3d)
    if h.surfacearea > 0
        return h.surfacearea
    end
    global TIME
    TIME += 1
    dfsArea(h, h.index)
    return h.surfacearea
end

# Horizon search
function getHorizon(h::ConvexHulls3d, fidx::Int, p::Vect, resdel::Vector{Int})
    f = FAC[fidx]
    if !isabove(p, f.p) return 0 end
    if f.vistime == TIME return -1 end
    f.vistime = TIME
    f.isdel   = true
    push!(resdel, fidx)
    ret = -2
    for i in 1:3
        r = getHorizon(h, f.n[i], p, resdel)
        if r == 0
            a = vecId(f.p, i)
            b = vecId(f.p, (i % 3) + 1)
            for (j, pt) in enumerate((a,b))
                slot = vistime[pt] != TIME ? 1 : 2
                vistime[pt] = TIME
                e[slot, pt] = Edge(j==1 ? b : a, f.n[i])
            end
            ret = a
        elseif r != -1 && r != -2
            ret = r
        end
    end
    return ret
end

# Build initial tetrahedron
function getStart(point::Vector{Vect}, totp::Int)
    # pick extremes
    pt = [ point[1] for _ in 1:6 ]
    for i in 1:totp
        v = point[i]
        if gtr(v.x, pt[1].x) pt[1] = v end
        if gtr(pt[2].x, v.x) pt[2] = v end
        if gtr(v.y, pt[3].y) pt[3] = v end
        if gtr(pt[4].y, v.y) pt[4] = v end
        if gtr(v.z, pt[5].z) pt[5] = v end
        if gtr(pt[6].z, v.z) pt[6] = v end
    end
    # furthest pair
    s = [pt[1], pt[2], point[1], point[1]]
    for i in 1:6, j in i+1:6
        d = dist_point_point(pt[i], pt[j])
        if gtr(d, dist_point_point(s[1], s[2]))
            s[1], s[2] = pt[i], pt[j]
        end
    end
    # furthest from line
    L = Line(s[1], s[2])
    s[3] = pt[1]
    for i in 1:6
        if gtr(dist_point_line(pt[i], L), dist_point_line(s[3], L))
            s[3] = pt[i]
        end
    end
    # furthest from plane
    s[4] = point[1]
    base = Plane(s[1], s[2], s[3])
    for i in 1:totp
        if gtr(abs(dist_point_plane(point[i], base)),
               abs(dist_point_plane(s[4],     base)))
            s[4] = point[i]
        end
    end
    if gtr(0, dist_point_plane(s[4], base))
        s[2], s[3] = s[3], s[2]
    end

    # create 4 facets
    fidx = Int[]
    for i in 1:4
        push!(FAC, Facet())
        FAC[end].id = length(FAC)
        push!(fidx, length(FAC))
    end
    FAC[fidx[1]].p = Plane(s[1], s[3], s[2])
    FAC[fidx[2]].p = Plane(s[1], s[2], s[4])
    FAC[fidx[3]].p = Plane(s[2], s[3], s[4])
    FAC[fidx[4]].p = Plane(s[3], s[1], s[4])

    FAC[fidx[1]].n = (fidx[4], fidx[3], fidx[2])
    FAC[fidx[2]].n = (fidx[1], fidx[3], fidx[4])
    FAC[fidx[3]].n = (fidx[1], fidx[4], fidx[2])
    FAC[fidx[4]].n = (fidx[1], fidx[2], fidx[3])

    # prepare pts lists
    for _ in 1:4
        push!(pts, Vect[])
    end

    # assign points
    for i in 1:totp
        v = point[i]
        if v == s[1] || v == s[2] || v == s[3] || v == s[4]
            continue
        end
        for j in 1:4
            if isabove(v, FAC[fidx[j]].p)
                push!(pts[fidx[j]], v)
                break
            end
        end
    end

    return ConvexHulls3d(fidx[1])
end

# Main QuickHull3D
function quickHull3d(point::Vector{Vect}, totp::Int)
    hull = getStart(point, totp)

    empty!(queue)
    push!(queue, hull.index)
    for i in 1:3
        push!(queue, FAC[hull.index].n[i])
    end
    snew = hull.index

    while !isempty(queue)
        nf = popfirst!(queue)
        if FAC[nf].isdel || isempty(pts[nf])
            if !FAC[nf].isdel
                snew = nf
            end
            continue
        end

        # farthest point
        p = pts[nf][1]
        for v in pts[nf]
            if gtr(dist_point_plane(v, FAC[nf].p),
                   dist_point_plane(p, FAC[nf].p))
                p = v
            end
        end

        # find horizon
        TIME += 1
        empty!(resfdel)
        s = getHorizon(hull, nf, p, resfdel)

        # build around horizon
        empty!(resfnew)
        TIME += 1
        from = -1; lastf = -1; fstf = -1
        while vistime[s] != TIME
            vistime[s] = TIME
            e1, e2 = e[1,s], e[2,s]
            net, adj = (e1.netid==from ? (e2.netid, e2.facetid)
                                       : (e1.netid, e1.facetid))
            # find edge orientation
            pt1 = findfirst(i->vecAt(FAC[adj].p,i)==point[s], 1:3)
            pt2 = findfirst(i->vecAt(FAC[adj].p,i)==point[net], 1:3)
            if (pt1 % 3) + 1 != pt2
                pt1, pt2 = pt2, pt1
            end

            newp = Plane(vecAt(FAC[adj].p,pt2),
                         vecAt(FAC[adj].p,pt1),
                         p)
            push!(FAC, Facet(length(FAC)+1, newp))
            fnew = length(FAC)
            push!(pts, Vect[])
            push!(resfnew, fnew)

            FAC[fnew].n = (adj,0,0)
            FAC[adj].n = setindex(FAC[adj].n, fnew, pt1)

            if lastf != -1
                if vecAt(FAC[fnew].p,2) == vecAt(FAC[lastf].p,1)
                    FAC[fnew].n = (FAC[fnew].n[1], lastf, FAC[fnew].n[3])
                    FAC[lastf].n = (FAC[lastf].n[1], FAC[lastf].n[2], fnew)
                else
                    FAC[fnew].n = (FAC[fnew].n[1], FAC[fnew].n[2], lastf)
                    FAC[lastf].n = (FAC[lastf].n[1], fnew, FAC[lastf].n[3])
                end
            else
                fstf = fnew
            end

            lastf, from, s = fnew, s, net
        end

        # close loop
        if vecAt(FAC[fstf].p,2) == vecAt(FAC[lastf].p,1)
            FAC[fstf].n = (FAC[fstf].n[1], lastf, FAC[fstf].n[3])
            FAC[lastf].n = (FAC[lastf].n[1], FAC[lastf].n[2], fstf)
        else
            FAC[fstf].n = (FAC[fstf].n[1], FAC[fstf].n[2], lastf)
            FAC[lastf].n = (FAC[lastf].n[1], fstf, FAC[lastf].n[3])
        end

        # collect and reassign points
        empty!(respt)
        for fid in resfdel
            append!(respt, pts[fid])
            empty!(pts[fid])
        end
        for v in respt
            if v != p
                for fid in resfnew
                    if isabove(v, FAC[fid].p)
                        push!(pts[fid], v)
                        break
                    end
                end
            end
        end

        for fid in resfnew
            push!(queue, fid)
        end
    end

    hull.index = snew
    return hull
end

# Example: unit tetrahedron
preConvexHulls()
points = [
    Vect(0.0,0.0,0.0,1),
    Vect(1.0,0.0,0.0,2),
    Vect(0.0,1.0,0.0,3),
    Vect(0.0,0.0,1.0,4),
]
hull = quickHull3d(points, length(points))
@printf("%.3f\n", getSurfaceArea(hull))
