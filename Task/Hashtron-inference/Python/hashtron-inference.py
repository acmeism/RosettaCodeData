def hash(n, s, max_val):
    # Mixing stage, mix input with salt using subtraction
    m = (n - s) & 0xFFFFFFFF
    # Hashing stage, use xor shift with prime coefficients
    m ^= (m << 2) & 0xFFFFFFFF
    m ^= (m << 3) & 0xFFFFFFFF
    m ^= (m >> 5) & 0xFFFFFFFF
    m ^= (m >> 7) & 0xFFFFFFFF
    m ^= (m << 11) & 0xFFFFFFFF
    m ^= (m << 13) & 0xFFFFFFFF
    m ^= (m >> 17) & 0xFFFFFFFF
    m ^= (m << 19) & 0xFFFFFFFF
    # Mixing stage 2, mix input with salt using addition
    m += s
    m &= 0xFFFFFFFF
    # Modular stage using Lemire's fast alternative to modulo reduction
    return ((m * max_val) >> 32) & 0xFFFFFFFF


def inference(command, bits, program):
    out = 0
    # Check if the program is empty
    if len(program) == 0:
        return out
    # Iterate over the bits
    for j in range(bits):
        input_val = command | (j << 16)
        ss, maxx = program[0]
        input_val = hash(input_val, ss, maxx)
        for i in range(1, len(program)):
            s, max_val = program[i]
            maxx -= max_val
            input_val = hash(input_val, s, maxx)
        input_val &= 1
        if input_val != 0:
            out |= 1 << j
    return out

print(inference(42,64,[[0,2]]))
