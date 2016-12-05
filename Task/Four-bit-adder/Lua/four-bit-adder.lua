-- Build XOR from AND, OR and NOT
function xor (a, b) return (a and not b) or (b and not a) end

-- Can make half adder now XOR exists
function halfAdder (a, b) return xor(a, b), a and b end

-- Full adder is two half adders with carry outputs OR'd
function fullAdder (a, b, cIn)
    local ha0s, ha0c = halfAdder(cIn, a)
    local ha1s, ha1c = halfAdder(ha0s, b)
    local cOut, s = ha0c or ha1c, ha1s
    return cOut, s
end

-- Carry bits 'ripple' through adders, first returned value is overflow
function fourBitAdder (a3, a2, a1, a0, b3, b2, b1, b0) -- LSB-first
    local fa0c, fa0s = fullAdder(a0, b0, false)
    local fa1c, fa1s = fullAdder(a1, b1, fa0c)
    local fa2c, fa2s = fullAdder(a2, b2, fa1c)
    local fa3c, fa3s = fullAdder(a3, b3, fa2c)
    return fa3c, fa3s, fa2s, fa1s, fa0s -- Return as MSB-first
end

-- Take string of noughts and ones, convert to native boolean type
function toBool (bitString)
    local boolList, bit = {}
    for digit = 1, 4 do
        bit = string.sub(string.format("%04d", bitString), digit, digit)
        if bit == "0" then table.insert(boolList, false) end
        if bit == "1" then table.insert(boolList, true) end
    end
    return boolList
end

-- Take list of booleans, convert to string of binary digits (variadic)
function toBits (...)
    local bStr = ""
    for i, bool in pairs{...} do
        if bool then bStr = bStr .. "1" else bStr = bStr .. "0" end
    end
    return bStr
end

-- Little driver function to neaten use of the adder
function add (n1, n2)
    local A, B = toBool(n1), toBool(n2)
    local v, s0, s1, s2, s3 = fourBitAdder( A[1], A[2], A[3], A[4],
                                            B[1], B[2], B[3], B[4] )
    return toBits(s0, s1, s2, s3), v
end

-- Main procedure (usage examples)
print("SUM", "OVERFLOW\n")
print(add(0001, 0001)) -- 1 + 1 = 2
print(add(0101, 1010)) -- 5 + 10 = 15
print(add(0000, 1111)) -- 0 + 15 = 15
print(add(0001, 1111)) -- 1 + 15 = 16 (causes overflow)
