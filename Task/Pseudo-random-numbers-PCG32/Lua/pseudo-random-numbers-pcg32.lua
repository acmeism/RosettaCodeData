function uint32(n)
    return n & 0xffffffff
end

function uint64(n)
    return n & 0xffffffffffffffff
end

N = 6364136223846793005
state = 0x853c49e6748fea9b
inc = 0xda3e39cb94b95bdb

function pcg32_seed(seed_state, seed_sequence)
    state = 0
    inc = (seed_sequence << 1) | 1
    pcg32_int()
    state = state + seed_state
    pcg32_int()
end

function pcg32_int()
    local old = state
    state = uint64(old * N + inc)
    local shifted = uint32(((old >> 18) ~ old) >> 27)
    local rot = uint32(old >> 59)
    return uint32((shifted >> rot) | (shifted << ((~rot + 1) & 31)))
end

function pcg32_float()
    return 1.0 * pcg32_int() / (1 << 32)
end

-------------------------------------------------------------------

pcg32_seed(42, 54)
print(pcg32_int())
print(pcg32_int())
print(pcg32_int())
print(pcg32_int())
print(pcg32_int())
print()

counts = { 0, 0, 0, 0, 0 }
pcg32_seed(987654321, 1)
for i=1,100000 do
    local j = math.floor(pcg32_float() * 5.0) + 1
    counts[j] = counts[j] + 1
end

print("The counts for 100,000 repetitions are:")
for i=1,5 do
    print("  " .. (i - 1) .. ": " .. counts[i])
end
