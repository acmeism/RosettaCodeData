using GeometryTypes
import Base.*

CliffordVector = Point{32, Float64}

e(n) = (v = zeros(32); v[(1 << n) + 1] = 1.0; CliffordVector(v))

randommultivector() = CliffordVector(rand(32))

randomvector() = sum(i -> rand() * e(i), 0:4)

bitcount(n) = (count = 0; while n != 0 n &= n - 1; count += 1 end; count)

function reorderingsign(i, j)
    ssum, i = 0, i >> 1
    while i != 0
        ssum += bitcount(i & j)
        i >>= 1
    end
    return iseven(ssum) ? 1.0 : -1.0
end

function Base.:*(v1::CliffordVector, v2::CliffordVector)
    result = zeros(32)
    for (i, x1) in enumerate(v1)
        if x1 != 0.0
            for (j, x2) in enumerate(v2)
                if x2 != 0.0
                    s = reorderingsign(i - 1, j - 1) * x1 * x2
                    k = (i - 1) ⊻ (j - 1)
                    result[k + 1] += s
                end
            end
        end
    end
    return CliffordVector(result)
end

function testcliffordvector()
    allorthonormal = true
    for i in 0:4, j in 0:4
        i < j && all(iszero, e(i) * e(j)) != 0.0 && (allorthonormal = false)
        i == j && !all(iszero, e(i) * e(j)) == 0.0 && (allorthonormal = false)
    end
    println("e(i) * e(j)  are orthonormal for i, j ϵ [0, 4]: ", allorthonormal)

    a, b, c = randommultivector(), randommultivector(), randommultivector()
    x = randomvector()

    @show (a * b) * c ≈ a * (b * c)
    @show a * (b + c) ≈ a * b + a * c
    @show (a + b) * c ≈ a * c + b * c

    isreal(x) = x[1] isa Real && all(iszero, x[2:end])
    @show isreal(x * x)
end


testcliffordvector()
