const mask32 = (0x1 << 32) - 1
const CONST = 0x2545F4914F6CDD1D

mutable struct XorShiftStar
     state::UInt64
end
	
XorShiftStar(_seed=0x0) = XorShiftStar(UInt(_seed))

seed(x::XorShiftStar, num) = begin x.state = UInt64(num) end

"""return random int between 0 and 2**32"""
function next_int(x::XorShiftStar)
    x.state = x.state ⊻ (x.state >> 12)
    x.state = x.state ⊻ (x.state << 25)
    x.state = x.state ⊻ (x.state >> 27)
    return ((x.state * CONST) >> 32) & mask32
end

"""return random float between 0 and 1"""
next_float(x::XorShiftStar) = next_int(x) / (1 << 32)

function testXorShiftStar()
    random_gen = XorShiftStar()
    seed(random_gen, 1234567)
    for i in 1:5
        println(next_int(random_gen))
    end
    seed(random_gen, 987654321)
    hist = fill(0, 5)
    for _ in 1:100_000
        hist[Int(floor(next_float(random_gen) * 5)) + 1] += 1
    end
    foreach(n -> print(n - 1, ": ", hist[n], "  "), 1:5)
end

testXorShiftStar()
