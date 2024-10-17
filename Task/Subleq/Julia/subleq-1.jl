module Subleq

using OffsetArrays

function interpret(allwords::AbstractVector{Int})
    words = OffsetArray(allwords, -1)
    buf = IOBuffer()
    ip = 0
    while true
        a, b, c = words[ip:ip+2]
        ip += 3
        if a < 0
            print("Enter a character: ")
            words[b] = parse(Int, readline(stdin))
        elseif b < 0
            print(buf, Char(words[a]))
        else
            words[b] -= words[a]
            if words[b] ≤ 0
                ip = c
            end
            ip < 0 && break
        end
    end
    return String(take!(buf))
end

interpret(src::AbstractString) = interpret(parse.(Int, split(src)))

end  # module Subleq
