function compress7(inio, outio)
    nextwritebyte = read(inio, UInt8) & 0x7f
    filled = 7
    while !eof(inio)
        inbyte = read(inio, UInt8)
        write(outio, UInt8(nextwritebyte | inbyte << filled))
        nextwritebyte = inbyte >> (8 - filled)
        filled = (filled + 7) % 8
        if filled == 0
            if eof(inio)
                break
            end
            nextwritebyte = read(inio, UInt8) & 0x7f
            filled = 7
        end
    end
    if filled != 0
        write(outio, UInt8(nextwritebyte))
    end
end

function expand7(inio, outio)
    newbyte = read(inio, UInt8)
    write(outio, UInt8(newbyte & 0x7f))
    residualbyte::UInt8 = newbyte >> 7
    filled = 1
    while !eof(inio)
        inbyte = read(inio, UInt8)
        write(outio, UInt8((residualbyte | inbyte << filled) & 0x7f))
        residualbyte = inbyte >> (7 - filled)
        filled = (filled + 1) % 7
        if filled == 0
            write(outio, UInt8(residualbyte & 0x7f))
            residualbyte = 0
        end
    end
end

str = b"These bit oriented I/O functions can be used to implement compressors and decompressors."
ins = IOBuffer(str)
outs = IOBuffer()
newouts = IOBuffer()
compress7(ins, outs)
seek(outs,0)
expand7(outs, newouts)
println("Initial string of length $(length(str)): ", String(ins.data))
println("Compressed to length $(length(outs.data)) on line below:\n", String(outs.data))
println("Decompressed string: ", String(newouts.data))
