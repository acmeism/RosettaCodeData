function crc32(crc::Int, str::String)
    table = zeros(UInt32, 256)

    for i in 0:255
        tmp = i
        for j in 0:7
            if tmp & 1 == 1
                tmp >>= 1
                tmp ⊻= 0xedb88320
            else
                tmp >>= 1
            end
        end

        table[i + 1] = tmp
    end

    crc ⊻= 0xffffffff

    for i in UInt32.(collect(str))
        crc = (crc >> 8) ⊻ table[(crc & 0xff) ⊻ i + 1]
    end

    crc ⊻ 0xffffffff
end

str = "The quick brown fox jumps over the lazy dog"
crc = crc32(0, str)
assert(crc == 0x414fa339)
println("Message: ", str)
println("Checksum: ", hex(crc))
