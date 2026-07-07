""" Balanced Ternary module for Rosetta Code """
module BalancedTernaries

export BalancedTernary, @bt_str


""" Canonical representation:
	digits are stored least-significant first.
	Zero is represented by Int8[]
"""
struct BalancedTernary <: Number
	digits::Vector{Int8}

	function BalancedTernary(d::Vector{Int8})
		i = length(d)
		while i > 0 && d[i] == 0
			i -= 1
		end
		new(copy(d[1:i]))
	end
end
BalancedTernary() = BalancedTernary(Int8[])
BalancedTernary(n::Integer) = convert(BalancedTernary, n)
BalancedTernary(s::AbstractString) = convert(BalancedTernary, s)

""" Conversion between digits and characters """
@inline digit2char(d::Int8) =
	d == -1 ? '-' :
	d == 0  ? '0' :
	d == 1  ? '+' :
	throw(ArgumentError("invalid digit $d"))

""" Conversion between characters and digits"""
@inline function char2digit(c::Char)
	c == '-' && return Int8(-1)
	c == '0' && return Int8(0)
	c == '+' && return Int8(1)
	throw(ArgumentError("invalid balanced ternary character '$c'"))
end

""" for display in REPL and printing """
function Base.show(io::IO, bt::BalancedTernary)
	if isempty(bt.digits) # special case: empty vector means zero
		print(io, "0")
		return
	end
	for d in Iterators.reverse(bt.digits)
		print(io, digit2char(d))
	end
end

""" copy constructor """
Base.copy(bt::BalancedTernary) = BalancedTernary(copy(bt.digits))

""" zero """
Base.zero(::Type{BalancedTernary}) = BalancedTernary()

""" one """
Base.one(::Type{BalancedTernary}) = BalancedTernary(Int8[1])

""" is zero """
Base.iszero(bt::BalancedTernary) = isempty(bt.digits)

""" Equality """
Base.:(==)(a::BalancedTernary, b::BalancedTernary) =
	a.digits == b.digits

""" Hashing """
Base.hash(bt::BalancedTernary, h::UInt) =
	hash(bt.digits, h)

""" Integer -> BalancedTernary """
function Base.convert(::Type{BalancedTernary}, n::Integer)
	iszero(n) && return BalancedTernary()
	digits = Int8[]
	while n != 0
		r = mod(n, 3)
		if r == 0
			push!(digits, 0)
			n = fld(n, 3)
		elseif r == 1
			push!(digits, 1)
			n = fld(n, 3)
		else
			push!(digits, -1)
			n = fld(n + 1, 3)
		end
	end
	BalancedTernary(digits)
end

""" String -> BalancedTernary """
function Base.convert(::Type{BalancedTernary},
	s::AbstractString)
	digits = Vector{Int8}(undef, lastindex(s))
	j = 1
	for i in lastindex(s):-1:firstindex(s)
		digits[j] = char2digit(s[i])
		j += 1
	end
	BalancedTernary(digits)
end

""" BalancedTernary -> Integer """
function Base.convert(::Type{T},
	bt::BalancedTernary) where {T <: Integer}
	x = zero(T)
	for d in Iterators.reverse(bt.digits)
		x = x * 3 + d
	end
	x
end

(::Type{T})(bt::BalancedTernary) where {T <: Integer} =
	convert(T, bt)

""" Negation of a BalancedTernary number (unary -) """
Base.:-(bt::BalancedTernary) =
	BalancedTernary(Int8[-d for d in bt.digits])

""" String literal macro for BalancedTernary numbers """
macro bt_str(s)
	convert(BalancedTernary, s)
end

""" Single-digit addition: returns (digit, carry) """
@inline function adddigits(a::Int8, b::Int8, carry::Int8)
	s = a + b + carry
	return s > 1 ? (Int8(s - 3), Int8(1)) :
		   s < -1 ? (Int8(s + 3), Int8(-1)) :
		   (Int8(s), Int8(0))
end

""" Internal addition of two vectors of digits, returns a BalancedTernary number """
function add_vectors(a::Vector{Int8}, b::Vector{Int8})
	na = length(a)
	nb = length(b)
	n = max(na, nb)
	result = Vector{Int8}(undef, n + 1)
	carry = Int8(0)
	@inbounds for i in 1:n
		da = i <= na ? a[i] : Int8(0)
		db = i <= nb ? b[i] : Int8(0)
		digit, carry = adddigits(da, db, carry)
		result[i] = digit
	end
	if carry != 0
		result[n+1] = carry
		resize!(result, n + 1)
	else
		resize!(result, n)
	end
	return BalancedTernary(result)
end

""" Addition of two BalancedTernary numbers """
Base.:+(a::BalancedTernary, b::BalancedTernary) = add_vectors(a.digits, b.digits)

""" Subtraction of two BalancedTernary numbers """
Base.:-(a::BalancedTernary, b::BalancedTernary) = add_vectors(a.digits, Int8.(-b.digits))

# Mixed arithmetic with Integers
Base.:+(a::BalancedTernary, b::Integer) = a + BalancedTernary(b)
Base.:+(a::Integer, b::BalancedTernary) = BalancedTernary(a) + b
Base.:-(a::BalancedTernary, b::Integer) = a - BalancedTernary(b)
Base.:-(a::Integer, b::BalancedTernary) = BalancedTernary(a) - b

# Promotion
Base.promote_rule(::Type{BalancedTernary},
	::Type{<:Integer}) = BalancedTernary
Base.convert(::Type{BalancedTernary},
	bt::BalancedTernary) = bt


""" Shift left by k ternary digits (multiply by 3^k) """
function shiftleft(bt::BalancedTernary, k::Integer)
	k < 0 && throw(ArgumentError("negative shift"))
	isempty(bt.digits) && return zero(BalancedTernary)
	v = Vector{Int8}(undef, length(bt.digits) + k)
	fill!(view(v, 1:k), Int8(0))
	copyto!(v, k + 1, bt.digits, 1, length(bt.digits))
	BalancedTernary(v)
end

""" Multiplication of two BalancedTernary numbers """
function Base.:*(a::BalancedTernary,
	b::BalancedTernary)
	iszero(a) && return zero(BalancedTernary)
	iszero(b) && return zero(BalancedTernary)
	result = zero(BalancedTernary)
	@inbounds for (shift, digit) in pairs(a.digits)
		digit == 0 && continue
		term = shiftleft(b, shift - 1)
		if digit == 1
			result += term
		else
			result -= term
		end
	end
	result
end

""" Mixed arithmetic multiplicatiion with Integers """
Base.:*(a::BalancedTernary, b::Integer) =
	a * BalancedTernary(b)
Base.:*(a::Integer, b::BalancedTernary) =
	BalancedTernary(a) * b

""" Absolute value of a BalancedTernary number """
Base.abs(bt::BalancedTernary) =
	isempty(bt.digits) || bt.digits[end] >= 0 ? copy(bt) : -bt

""" Exponentiation of a BalancedTernary number to an integer power """
function Base.:^(bt::BalancedTernary, n::Integer)
	n < 0 && throw(ArgumentError("negative exponent"))
	iszero(n) && return one(BalancedTernary)
	result = one(BalancedTernary)
	base = copy(bt)
	while n > 0
		if isodd(n)
			result *= base
		end
		base *= base
		n = fld(n, 2)
	end
	return result
end

""" Exponentiation of an integer to a BalancedTernary power """
function Base.:^(a::Integer, bt::BalancedTernary)
	iszero(bt) && return one(BalancedTernary)
	iszero(a) && return zero(BalancedTernary)
	result = one(BalancedTernary)
	base = BalancedTernary(a)
	for d in Iterators.reverse(bt.digits)
		result = result ^ 3
		if d == 1
			result *= base
		elseif d == -1
			result *= -base
		end
	end
	return result
end

""" Exponentiation of a BalancedTernary number to a BalancedTernary power """
function Base.:^(bt1::BalancedTernary, bt2::BalancedTernary)
	iszero(bt2) && return one(BalancedTernary)
	iszero(bt1) && return zero(BalancedTernary)
	result = one(BalancedTernary)
	for d in Iterators.reverse(bt2.digits)
		result = result ^ 3
		if d == 1
			result *= bt1
		elseif d == -1
			result *= -bt1
		end
	end
	return result
end


end # module BalancedTernaries

using .BalancedTernaries

# Task example: a * (b - c)
a = bt"+-0++0+" # This uses the string literal macro @bt_str for bt""
println("a = ", a)
println("Int(a) = ", Int(a))
b = BalancedTernary(-436)
println("b = ", b)
println("Int(b) = ", Int(b))
c = BalancedTernary("+-++-")
println("c = ", c)
println("Int(c) = ", Int(c))

r = a * (b - c)
println("\nr = a * (b - c)")
println("r as balanced : ", r)
println("r as integer  : ", Int(r), "\n")
@assert Int(r) == Int(a) * (Int(b) - Int(c))

@show r ^ 10
@show 10 ^ c
@show BigInt(10 ^ c)
@show b ^ c
@show BigInt(b ^ c)
