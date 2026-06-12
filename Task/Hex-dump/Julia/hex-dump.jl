function baseddump(io::IO, data::Vector{UInt8}; base = 16, offset = 0, len = -1, displayadjust = 0)
    @assert 2 <= base <= 16 "display base $base not supported"
    datastop = len < 0 ? length(data) : min(offset + len, length(data))
    bytes = data[begin+offset:datastop]
    fullchunksize = base == 16 ? 16 : base > 8 ? 10 : base > 4 ? 8 : 6
    padsize = base == 16 ? 2 : base == 2 ? 8 : base > 7 ? 3 : base > 3 ? 4 : 5
    midpad = " "^(base != 2)
    vl = (padsize + 1) * fullchunksize + length(midpad)
    halflen, pos = fullchunksize ÷ 2, offset + displayadjust
    for chunk in Iterators.partition(bytes, fullchunksize)
        chunklen = length(chunk)
        values = map(n -> string(n, base = base, pad = padsize) * " ", chunk)
        s1 = join(values[begin:begin+min(halflen, chunklen)-1])
        if chunklen > halflen
            s1 *= midpad * join(values[begin+halflen:end])
        end
        s2 = prod(map(n -> n < 128 && isprint(Char(n)) ? Char(n) : '.', chunk))
        println(io, string(pos, base = 16, pad = 8) * " " * rpad(s1, vl) * "|" * s2 * "|")
        pos += chunklen
    end
    println(io, string(pos - offset - displayadjust, base = 16, pad = 8))
end
function baseddump(data; base = 16, offset = 0, len = -1)
    return baseddump(vec(collect(reinterpret(UInt8, data))); base, offset, len)
end
function baseddump(filename::AbstractString; base = 16, offset = 0, len = -1)
    fromio = open(filename)
    flen = stat(fromio).size
    len = len < 0 ? flen - offset : min(len, flen - offset)
    offset != 0 && seek(fromio, offset)
    data::Vector{UInt8} = read(fromio, len)
    baseddump(data; base = base, offset = 0, displayadjust = offset)
    close(fromio)
end
hexdump(data; offset = 0, len = -1) = baseddump(data; offset, len)
xxd(data; offset = 0, len = -1) = baseddump(data; base = 2, offset, len)
decdump(data; offset = 0, len = -1) = baseddump(data; base = 10, offset, len)

const tstr = b"Rosetta Code is a programming chrestomathy site 😀."
const utf16 = vcat(b"\xff\xfe", reinterpret(UInt8, transcode(UInt16, tstr)))
print("hexdump of utf-16 string "), display(String(tstr))
hexdump(utf16)
print("\nxxd of utf-16 string "), display(String(tstr))
xxd(utf16)
print("\ndecdump of utf-16 string "), display(String(tstr))
decdump(utf16)
println("\nbaseddump of utf-16 string bytes 16-56 from file:")
fname = tempname()
open(fname, "w") do fd; write(fd, utf16) end
baseddump(fname, offset = 16, len = 40)

