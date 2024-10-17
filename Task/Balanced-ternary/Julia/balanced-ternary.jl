struct BalancedTernary <: Signed
    digits::Vector{Int8}
end
BalancedTernary() = zero(BalancedTernary)
BalancedTernary(n) = convert(BalancedTernary, n)

const sgn2chr = Dict{Int8,Char}(-1 => '-', 0 => '0', +1 => '+')
Base.show(io::IO, bt::BalancedTernary) = print(io, join(sgn2chr[x] for x in reverse(bt.digits)))
Base.copy(bt::BalancedTernary) = BalancedTernary(copy(bt.digits))
Base.zero(::Type{BalancedTernary}) = BalancedTernary(Int8[0])
Base.iszero(bt::BalancedTernary) = bt.digits == Int8[0]
Base.convert(::Type{T}, bt::BalancedTernary) where T<:Number = sum(3 ^ T(ex - 1) * s for (ex, s) in enumerate(bt.digits))
function Base.convert(::Type{BalancedTernary}, n::Signed)
    r = BalancedTernary(Int8[])
    if iszero(n) push!(r.digits, 0) end
    while n != 0
        if mod(n, 3) == 0
            push!(r.digits, 0)
            n = fld(n, 3)
        elseif mod(n, 3) == 1
            push!(r.digits, 1)
            n = fld(n, 3)
        else
            push!(r.digits, -1)
            n = fld(n + 1, 3)
        end
    end
    return r
end
const chr2sgn = Dict{Char,Int8}('-' => -1, '0' => 0, '+' => 1)
function Base.convert(::Type{BalancedTernary}, s::AbstractString)
    return BalancedTernary(getindex.(chr2sgn, collect(reverse(s))))
end

macro bt_str(s)
    convert(BalancedTernary, s)
end

const table = NTuple{2,Int8}[(0, -1), (1, -1), (-1, 0), (0, 0), (1, 0), (-1, 1), (0, 1)]
function _add(a::Vector{Int8}, b::Vector{Int8}, c::Int8=Int8(0))
    if isempty(a) || isempty(b)
        if c == 0 return isempty(a) ? b : a end
        return _add([c], isempty(a) ? b : a)
    else
        d, c = table[4 + (isempty(a) ? 0 : a[1]) + (isempty(b) ? 0 : b[1]) + c]
        r = _add(a[2:end], b[2:end], c)
        if !isempty(r) || d != 0
            return unshift!(r, d)
        else
            return r
        end
    end
end
function Base.:+(a::BalancedTernary, b::BalancedTernary)
    v = _add(a.digits, b.digits)
    return isempty(v) ? BalancedTernary(0) : BalancedTernary(v)
end
Base.:-(bt::BalancedTernary) = BalancedTernary(-bt.digits)
Base.:-(a::BalancedTernary, b::BalancedTernary) = a + (-b)
function _mul(a::Vector{Int8}, b::Vector{Int8})
    if isempty(a) || isempty(b)
        return Int8[]
    else
        if a[1] == -1 x = (-BalancedTernary(b)).digits
        elseif a[1] == 0 x = Int8[]
        elseif a[1] == 1 x = b end
        y = append!(Int8[0], _mul(a[2:end], b))
        return _add(x, y)
    end
end
function Base.:*(a::BalancedTernary, b::BalancedTernary)
    v = _mul(a.digits, b.digits)
    return isempty(v) ? BalancedTernary(0) : BalancedTernary(v)
end

a = bt"+-0++0+"
println("a: $(Int(a)), $a")
b = BalancedTernary(-436)
println("b: $(Int(b)), $b")
c = BalancedTernary("+-++-")
println("c: $(Int(c)), $c")
r = a * (b - c)
println("a * (b - c): $(Int(r)), $r")

@assert Int(r) == Int(a) * (Int(b) - Int(c))
