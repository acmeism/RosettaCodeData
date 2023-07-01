diagram = """
         +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
         |                      ID                       |
         +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
         |QR|   Opcode  |AA|TC|RD|RA|   Z    |   RCODE   |
         +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
         |                    QDCOUNT                    |
         +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
         |                    ANCOUNT                    |
         +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
         |                    NSCOUNT                    |
         +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
         |                    ARCOUNT                    |
         +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+"""

testhexdata = "78477bbf5496e12e1bf169a4"

struct BitField
    name::String
    bits::Int
    fieldstart::Int
    fieldend::Int
end

function diagramtostruct(txt)
    bitfields = Vector{BitField}()
    lines = map(strip, split(txt, "\n"))
    for row in 1:2:length(lines)-1
        nbits = sum(x -> x == '+', lines[row]) - 1
        fieldpos = findall(x -> x == '|', lines[row + 1])
        bitaccum = div(row, 2) * nbits
        for (i, field) in enumerate(fieldpos[1:end-1])
            endfield = fieldpos[i + 1]
            bitsize = div(endfield - field, 3)
            bitlabel = strip(lines[row + 1][field+1:endfield-1])
            bitstart = div(field - 1, 3) + bitaccum
            bitend = bitstart + bitsize - 1
            push!(bitfields, BitField(bitlabel, bitsize, bitstart, bitend))
        end
    end
    bitfields
end

binbyte(c) = string(parse(UInt8, c, base=16), base=2, pad=8)
hextobinary(s) = reduce(*, map(binbyte, map(x -> s[x:x+1], 1:2:length(s)-1)))
validator(binstring, fields) = length(binstring) == sum(x -> x.bits, fields)

function bitreader(bitfields, hexdata)
    println("\nEvaluation of hex data $hexdata as bitfields:")
    println("Name     Size          Bits\n-------  ----  ----------------")
    b = hextobinary(hexdata)
    @assert(validator(b, bitfields))
    for bf in bitfields
        pat = b[bf.fieldstart+1:bf.fieldend+1]
        println(rpad(bf.name, 9), rpad(bf.bits, 6), lpad(pat, 16))
    end
end

const decoded = diagramtostruct(diagram)

println("Diagram as bit fields:\nName    Bits  Start  End\n------  ----  -----  ---")
for bf in decoded
    println(rpad(bf.name, 8), rpad(bf.bits, 6), rpad(bf.fieldstart, 6), lpad(bf.fieldend, 4))
end

bitreader(decoded, testhexdata)
