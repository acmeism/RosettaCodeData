const k8 = [ 4, 10,  9,  2, 13,  8,  0, 14,  6, 11,  1, 12,  7, 15,  5,  3]
const k7 = [14, 11,  4, 12,  6, 13, 15, 10,  2,  3,  8,  1,  0,  7,  5,  9]
const k6 = [ 5,  8,  1, 13, 10,  3,  4,  2, 14, 15, 12,  7,  6,  0,  9, 11]
const k5 = [ 7, 13, 10,  1,  0,  8,  9, 15, 14,  4,  6, 12, 11,  2,  5,  3]
const k4 = [ 6, 12,  7,  1,  5, 15, 13,  8,  4, 10,  9, 14,  0,  3, 11,  2]
const k3 = [ 4, 11, 10,  0,  7,  2,  1, 13,  3,  6,  8,  5,  9, 12, 15, 14]
const k2 = [13, 11,  4,  1,  3, 15,  5,  9,  0, 10, 14,  7,  6,  8,  2, 12]
const k1 = [ 1, 15, 13,  0,  5,  7, 10,  4,  9,  2,  3, 14,  6, 11,  8, 12]
const k87 = zeros(UInt32,256)
const k65 = zeros(UInt32,256)
const k43 = zeros(UInt32,256)
const k21 = zeros(UInt32,256)
for i in 1:256
    j = (i-1) >> 4 + 1
    k = (i-1) & 15 + 1
    k87[i] = (k1[j] << 4) | k2[k]
    k65[i] = (k3[j] << 4) | k4[k]
    k43[i] = (k5[j] << 4) | k6[k]
    k21[i] = (k7[j] << 4) | k8[k]
end

function f(x)
    y = (k87[(x>>24) & 0xff + 1] << 24) | (k65[(x>>16) & 0xff + 1] << 16) |
        (k43[(x>> 8) & 0xff + 1] <<  8) | k21[x & 0xff + 1]
    (y << 11) | (y >> (32-11))
end

bytes2int(arr) = reinterpret(UInt32, arr)[begin]
int2bytes(x) = reinterpret(UInt8, [x])

function mainstep(inputbytes, keybytes)
    intkey = bytes2int(keybytes)
    lowint = bytes2int(inputbytes[1:4])
    topint = bytes2int(inputbytes[5:8])
    xorbytes = f(UInt32(intkey) + UInt32(lowint)) ⊻ topint
    vcat(int2bytes(xorbytes), inputbytes[1:4])
end

const input = [0x21, 0x04, 0x3B, 0x04, 0x30, 0x04, 0x32, 0x04]
const key = [0xF9, 0x04, 0xC1, 0xE2]
println("The encoded bytes are $(mainstep(input, key))")
