bwsort(vec) = sort(vec, lt = (a, b) -> string(a) < string(b))

function burrowswheeler_encode(s)
    if match(r"\x02|\x03", s) != nothing
        throw("String for Burrows-Wheeler input cannot contain STX or ETX")
    end
    s = "\x02" * s * "\x03"
    String([t[end] for t in bwsort([circshift([c for c in s], n) for n in 0:length(s)-1])])
end

function burrowswheeler_decode(s)
    len, v = length(s), [c for c in s]
    m = fill(' ', len, len)
    for col in len:-1:1
        m[:, col] .= v
        for (i, row) in enumerate(bwsort([collect(r) for r in eachrow(m)]))
            m[i, :] .= row
        end
    end
    String(m[findfirst(row -> m[row, end] == '\x03', 1:len), 2:end-1])
end

for s in ["BANANA", "dogwood", "SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES",
    "TO BE OR NOT TO BE OR WANT TO BE OR NOT?", "Oops\x02"]
    println("Original: ", s, "\nTransformation: ", burrowswheeler_encode(s),
        "\nInverse transformation: ", burrowswheeler_decode(burrowswheeler_encode(s)), "\n")
end
