import Base.show, Base.==, Base.hash

struct Point x::Float64; y::Float64 end
hash(p::Point) = hash(p.x, hash(p.y))
==(p1::Point, p2::Point) = p1.x == p2.x && p1.y == p2.y

pointsort!(pv) = sort!(pv, lt = (a, b) -> a.x == b.x ? a.y < b.y : a.x < b.x)

mutable struct Poly
    vp::Vector{Point}
    Poly(v::Vector{Point}) = new(pointsort!(unique(v)))
end
Poly(poly::Poly) = Poly(poly.vp)
Poly(poly::Poly, v::Vector{Point}) = Poly(vcat(poly.vp, v))
Poly(poly, f::Function) = Poly(pointsort!(map(p -> f(p), deepcopy(poly.vp))))
==(p1::Poly, p2::Poly) = length(p1.vp) == length(p2.vp) &&
    all(i -> p1.vp[i] == p2.vp[i], 1:length(p1.vp))
hash(p1::Poly) = reduce((x, y) -> hash(hash(x), hash(y)), p1.vp)

polysort!(polyarr) = sort!(polyarr, lt = (a, b) -> string(a.vp) < string(b.vp))

translate_to_origin(poly) = Poly(poly, p -> Point(p.x - minimum(p -> p.x, poly.vp),
    p.y - minimum(p -> p.y, poly.vp)))

function asciimatrix(poly)
    if length(poly.vp) == 0
        return reshape(Char[], 0, 0)
    elseif length(poly.vp) == 1
        return reshape([' '], 1, 1)
    end
    vp = translate_to_origin(poly).vp
    sz = Int.((maximum(p -> p.x, vp), maximum(p -> p.y, vp))) .+ 1
    txtmat = fill(' ', sz)
    for i in 1:sz[1], j in 1:sz[2]
        if Point(i-1, j-1) in vp
            txtmat[i, j] = '#'
        end
    end
    txtmat
end

rotate90(poly) = Poly(poly, p -> Point(p.y, -p.x))
rotate180(poly) = Poly(poly, p -> Point(-p.x, -p.y))
rotate270(poly) = Poly(poly, p -> Point(-p.y, p.x))
reflect(poly) = Poly(poly, p -> Point(-p.x, p.y))

rotations_and_reflections(poly) = [poly, rotate90(poly), rotate180(poly),
    rotate270(poly), reflect(poly), reflect(rotate90(poly)),
    reflect(rotate180(poly)), reflect(rotate270(poly))]

canonical(poly) = polysort!(map(translate_to_origin, rotations_and_reflections(poly)))

contiguous(p) = [Point(p.x - 1, p.y), Point(p.x + 1, p.y),
    Point(p.x, p.y - 1), Point(p.x, p.y + 1)]

adjacentpoints(poly) = unique(filter(p -> !(p in poly.vp),
    reduce(vcat, [contiguous(p) for p in poly.vp])))

nextrank_adjacentpolys(poly) = map(pv -> pv[1], unique(canonical.(
    [Poly(poly, [p]) for p in adjacentpoints(poly)])))

const nullmino = Poly[]
const monomino = Poly([Point(0, 0)])

rank(n) = @assert n >= 0 && return n == 0 ? nullmino : n == 1 ? [monomino] :
    unique(reduce(vcat, map(nextrank_adjacentpolys, rank(n - 1))))

function Base.show(io::IO, poly::Poly)
    txtmat = asciimatrix(poly)
    w, h = size(txtmat)
    for i in 1:w
        for j in 1:h
            print(txtmat[i, j])
        end
        println()
    end
end

function testpolys(N = 5)
    println([length(rank(n)) for n in 1:10])

    println("\nAll free polyominoes of rank $N:")

    for poly in rank(5)
        println(poly)
    end
end

testpolys()
