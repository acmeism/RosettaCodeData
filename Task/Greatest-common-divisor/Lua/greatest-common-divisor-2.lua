function gcd(a,b)
    while b~=0 do
        a,b=b,a%b
    end
    return math.abs(a)
end
