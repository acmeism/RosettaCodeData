const mask32, CONST = 0xffffffff, UInt(6364136223846793005)

mutable struct PCG32
    state::UInt64
    inc::UInt64
    PCG32(st=0x853c49e6748fea9b, i=0xda3e39cb94b95bdb) = new(st, i)
end

"""return random 32 bit unsigned int"""
function next_int!(x::PCG32)
    old = x.state
    x.state = (old * CONST) + x.inc
    xorshifted = (((old >> 18) ⊻ old) >> 27) & mask32
    rot = (old >> 59) & mask32
    return ((xorshifted >> rot) | (xorshifted << ((-rot) & 31))) & mask32
end

"""return random float between 0 and 1"""
next_float!(x::PCG32) = next_int!(x) / (1 << 32)

function seed!(x::PCG32, st, seq)
    x.state = 0x0
    x.inc = (UInt(seq) << 0x1) | 1
    next_int!(x)
    x.state = x.state + UInt(st)
    next_int!(x)
end

function testPCG32()
    random_gen = PCG32()
    seed!(random_gen, 42, 54)
    for _ in 1:5
        println(next_int!(random_gen))
    end
    seed!(random_gen, 987654321, 1)
    hist = fill(0, 5)
    for _ in 1:100_000
        hist[Int(floor(next_float!(random_gen) * 5)) + 1] += 1
    end
    println(hist)
    for n in 1:5
        print(n - 1, ": ", hist[n], "  ")
    end
end

testPCG32()
