const C1 = 0x9e3779b97f4a7c15
const C2 = 0xbf58476d1ce4e5b9
const C3 = 0x94d049bb133111eb

mutable struct Splitmix64
    state::UInt
end

""" return random int between 0 and 2**64 """
function next_int(smx::Splitmix64)
    z = smx.state = smx.state + C1
    z = (z ⊻ (z >> 30)) * C2
    z = (z ⊻ (z >> 27)) * C3
    return z ⊻ (z >> 31)
end

""" return random float between 0 and 1 """
next_float(smx::Splitmix64) = next_int(smx) / one(Int128) << 64

function testSplitmix64()
    random_gen = Splitmix64(1234567)
    for i in 1:5
        println(next_int(random_gen))
    end

    random_gen = Splitmix64(987654321)
    hist = fill(0, 5)
    for _ in 1:100_000
        hist[Int(floor(next_float(random_gen) * 5)) + 1] += 1
    end
    foreach(n -> print(n - 1, ": ", hist[n], "  "), 1:5)
end

testSplitmix64()
