function gcd(a,b)
    while b~=0 do
        a,b=b,a%b
    end
    return math.abs(a)
end
function pollard_rho(n)
    local x, y, d = 2, 2, 1
    local g = function(x) return (x*x+1) % n end
    while d == 1 do
        x = g(x)
        y = g(g(y))
        d = gcd(math.abs(x-y),n)
    end
    if d == n then return d end
    return math.min(d, math.floor( n/d ) )
end

local ar, product = {2}, 2
repeat
    ar[ #ar + 1 ] = pollard_rho( product + 1 )
    product       = product * ar[ #ar ]
until #ar >= 8
print( table.concat(ar, " ") )
