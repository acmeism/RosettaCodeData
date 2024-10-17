const a1 = [0, 1403580, -810728]
const m1 = 2^32 - 209
const a2 = [527612, 0, -1370589]
const m2 = 2^32 - 22853
const d = m1 + 1

mutable struct MRG32k3a
    x1::Tuple{Int64, Int64, Int64}
    x2::Tuple{Int64, Int64, Int64}
    MRG32k3a() = new((0, 0, 0), (0, 0, 0))
    MRG32k3a(seed_state) = new((seed_state, 0, 0), (seed_state, 0, 0))
end
seed(sd) = begin @assert(0 < sd < d); MRG32k3a(sd) end

function next_int(x::MRG32k3a)
    x1i = mod1(a1[1] * x.x1[1] + a1[2] * x.x1[2] + a1[3] * x.x1[3], m1)
    x2i = mod1(a2[1] * x.x2[1] + a2[2] * x.x2[2] + a2[3] * x.x2[3], m2)
    x.x1 = (x1i, x.x1[1], x.x1[2])
    x.x2 = (x2i, x.x2[1], x.x2[2])
    return mod1(x1i - x2i, m1) + 1
end

next_float(x::MRG32k3a) = next_int(x) / d

const g1 = seed(1234567)
for _ in 1:5
    println(next_int(g1))
end
const g2 = seed(987654321)
hist = fill(0, 5)
for _ in 1:100_000
    hist[Int(floor(next_float(g2) * 5)) + 1] += 1
end
foreach(p -> print(p[1], ": ", p[2], "  "), enumerate(hist))
