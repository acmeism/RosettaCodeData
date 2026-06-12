""" base 2 type Montgomery numbers """
struct Montgomery2
    m::BigInt
    n::Int64
    rrm::BigInt
end

function Montgomery2(x::BigInt)
    bitlen = length(string(x, base=2))
    r = (x == 0) ? 0 : (BigInt(1) << (bitlen * 2)) % x
    Montgomery2(x, bitlen, r)
end
Montgomery2(n) = Montgomery2(BigInt(n))

function reduce(mm::Montgomery2, t)
    a = BigInt(t)
    for i in 1:mm.n
        if isodd(a)
            a += mm.m
        end
        a >>= 1
    end
    return a >= mm.m ? a - mm.m : a
end

BASE(::Montgomery2) = 2

const mmm = Montgomery2(20)

function testmontgomery2()
    m = big"750791094644726559640638407699"
    x1 = big"540019781128412936473322405310"
    x2 = big"515692107665463680305819378593"

    mont = Montgomery2(m)
    t1 = x1 * mont.rrm
    t2 = x2 * mont.rrm
    r1 = reduce(mont, t1)
    r2 = reduce(mont, t2)
    r = 1 << mont.n
    println("b : ", BASE(mont))
    println("n : ", mont.n)
    println("r : ", r)
    println("m : ", mont.m)
    println("t1: ", t1)
    println("t2: ", t2)
    println("r1: ", r1)
    println("r2: ", r2)
    println()
    println("Original x1       :", x1)
    println("Recovered from r1 :", reduce(mont, r1))
    println("Original x2       :", x2)
    println("Recovered from r2 :", reduce(mont, r2))
    println("\nMontgomery computation of x1 ^ x2 mod m:")
    prod = reduce(mont, mont.rrm)
    base = reduce(mont, x1 * mont.rrm)
    pow = x2
    while pow > 0
        if isodd(pow)
            prod = reduce(mont, prod * base)
        end
        pow >>= 1
        base = reduce(mont, base * base)
    end
    println(reduce(mont, prod))
    println("\nAlternate computation of x1 ^ x2 mod m :")
    println(powermod(x1, x2, m))
end

testmontgomery2()
