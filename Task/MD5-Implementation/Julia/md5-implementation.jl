# a rather literal translation of the pseudocode at https://en.wikipedia.org/wiki/MD5

const s = UInt32[7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22,
                 5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20,
                 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23,  4, 11, 16, 23,
                 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21]

const K = UInt32[0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee, 0xf57c0faf,
    0x4787c62a, 0xa8304613, 0xfd469501, 0x698098d8, 0x8b44f7af, 0xffff5bb1,
    0x895cd7be, 0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821, 0xf61e2562,
    0xc040b340, 0x265e5a51, 0xe9b6c7aa, 0xd62f105d, 0x02441453, 0xd8a1e681,
    0xe7d3fbc8, 0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed, 0xa9e3e905,
    0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a, 0xfffa3942, 0x8771f681, 0x6d9d6122,
    0xfde5380c, 0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70, 0x289b7ec6,
    0xeaa127fa, 0xd4ef3085, 0x04881d05, 0xd9d4d039, 0xe6db99e5, 0x1fa27cf8,
    0xc4ac5665, 0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039, 0x655b59c3,
    0x8f0ccc92, 0xffeff47d, 0x85845dd1, 0x6fa87e4f, 0xfe2ce6e0, 0xa3014314,
    0x4e0811a1, 0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391]

function md5(msgbytes)
    a0::UInt32 = 0x67452301  # A
    b0::UInt32 = 0xefcdab89  # B
    c0::UInt32 = 0x98badcfe  # C
    d0::UInt32 = 0x10325476  # D

    oldlen = length(msgbytes)
    umsg = push!([UInt8(b) for b in msgbytes], UInt8(0x80))
    while length(umsg) % 64 != 56
        push!(umsg, UInt8(0))
    end
    append!(umsg, reinterpret(UInt8, [htol(UInt64(oldlen) * 8)]))

    for j in 1:64:length(umsg)-1
        arr = view(umsg, j:j+63)
        M = [reinterpret(UInt32, arr[k:k+3])[1] for k in 1:4:62]
        A = a0
        B = b0
        C = c0
        D = d0

        for i in 0:63
            if 0 ≤ i ≤ 15
                F = D ⊻ (B & (C ⊻ D))
                g = i
            elseif 16 ≤ i ≤ 31
                F = C ⊻ (D & (B ⊻ C))
                g = (5 * i + 1) % 16
            elseif 32 ≤ i ≤ 47
                F = B ⊻ C ⊻ D
                g = (3 * i + 5) % 16
            elseif 48 ≤ i ≤ 63
                F = C ⊻ (B | (~D))
                g = (7 * i) % 16
            end
            F += A + K[i+1] + M[g+1]
            A = D
            D = C
            C = B
            B += ((F) << s[i+1]) | (F >> (32 - s[i+1]))
        end

        a0 += A
        b0 += B
        c0 += C
        d0 += D
    end
    digest = join(map(x -> lpad(string(x, base=16), 2, '0'), reinterpret(UInt8, [a0, b0, c0, d0])), "") # Output is in little-endian
end

for pair in [0xd41d8cd98f00b204e9800998ecf8427e => "", 0x0cc175b9c0f1b6a831c399e269772661 => "a",
   0x900150983cd24fb0d6963f7d28e17f72 => "abc", 0xf96b697d7cb7938d525a2f31aaf161d0 => "message digest",
   0xc3fcd3d76192e4007dfb496cca67e13b => "abcdefghijklmnopqrstuvwxyz",
   0xd174ab98d277d9f5a5611c2c9f419d9f => "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
   0x57edf4a22be3c955ac49da2e2107b67a => "12345678901234567890123456789012345678901234567890123456789012345678901234567890"]
   println("MD5 of $(pair[2]) is $(md5(pair[2])), which checks with $(string(pair[1], base=16)).")
end
