const SLEN = 3

autobet() = randbool(SLEN)
function autobet(ob::BitArray{1})
    rlen = length(ob)
    2 < rlen || return ~ob
    3 < rlen || return [~ob[2], ob[1:2]]
    opt = falses(rlen)
    opt[1] = true
    opt[end-1:end] = true
    ob != opt || return ~opt
    return opt
end
autobet(ob::Array{Bool,1}) = autobet(convert(BitArray{1}, ob))

function pgencode{T<:String}(a::T)
    b = uppercase(a)
    0 < length(b) || return trues(0)
    !ismatch(r"[^HT]+", b) || error(@sprintf "%s is not a HT sequence" a)
    b = split(b, "")
    b .== "H"
end
pgdecode(a::BitArray{1}) = join([i ? "H" : "T" for i in a], "")

function humanbet()
    b = ""
    while length(b) != SLEN  || ismatch(r"[^HT]+", b)
        print("Your bet? ")
        b = uppercase(chomp(readline()))
    end
    return b
end
