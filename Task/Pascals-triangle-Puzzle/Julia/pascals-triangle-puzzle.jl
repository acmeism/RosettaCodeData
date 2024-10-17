function pascal(a::Integer, b::Integer, mid::Integer, top::Integer)
    yd = round((top - 4 * (a + b)) / 7)
    !isinteger(yd) && return 0, 0, 0
    y  = Int(yd)
    x  = mid - 2a - y
    return x, y, y - x
end

x, y, z = pascal(11, 4, 40, 151)
if !iszero(x)
    println("Solution: x = $x, y = $y, z = $z.")
else
    println("There is no solution.")
end
