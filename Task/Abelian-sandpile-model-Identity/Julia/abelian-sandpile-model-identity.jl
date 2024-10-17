import Base.+, Base.print

struct Sandpile
    pile::Matrix{UInt8}
end

function Sandpile(s::String)
    arr = [parse(UInt8, x.match) for x in eachmatch(r"\d+", s)]
    siz = isqrt(length(arr))
    return Sandpile(reshape(UInt8.(arr), siz, siz)')
end

const HMAX = 3

function avalanche!(s::Sandpile, lim=HMAX)
    nrows, ncols = size(s.pile)
    while any(x -> x > lim, s.pile)
        for j in 1:ncols, i in 1:nrows
            if s.pile[i, j] > lim
                i > 1 && (s.pile[i - 1, j] += 1)
                i < nrows && (s.pile[i + 1, j] += 1)
                j > 1 && (s.pile[i, j - 1] += 1)
                j < ncols && (s.pile[i, j + 1] += 1)
                s.pile[i, j] -= 4
            end
        end
    end
    s
end

+(s1::Sandpile, s2::Sandpile) = avalanche!(Sandpile((s1.pile + s2.pile)))

function print(io::IO, s::Sandpile)
    for row in 1:size(s.pile)[1]
        for col in 1:size(s.pile)[2]
            print(io, lpad(s.pile[row, col], 4))
        end
        println()
    end
end

const s1 = Sandpile("""
    1 2 0
    2 1 1
    0 1 3""")

const s2 = Sandpile("""
    2 1 3
    1 0 1
    0 1 0""")

const s3 = Sandpile("""
    3 3 3
    3 3 3
    3 3 3""")

const s3_id = Sandpile("""
    2 1 2
    1 0 1
    2 1 2""")

const s3a = Sandpile("""
    4 3 3
    3 1 2
    0 2 3""")

println("Avalanche reduction to group:\n", s3a, "   =>")
println(avalanche!(s3a), "\n")

println("Commutative Property:\ns1 + s2 =\n", s1 + s2, "\ns2 + s1 =\n", s2 + s1, "\n")

println("Addition:\n", s3, "   +\n", s3_id, "   =\n", s3 + s3_id, "\n")
println(s3_id, "   +\n", s3_id, "   =\n", s3_id + s3_id, "\n")
