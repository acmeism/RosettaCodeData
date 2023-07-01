-- primality by Wilson's theorem

function isWilsonPrime( n )
    local fmodp = 1
    for i = 2, n - 1 do
        fmodp = fmodp * i
        fmodp = fmodp % n
    end
    return fmodp == n - 1
end

for n = -1, 100 do
    if isWilsonPrime( n ) then
       io.write( " " .. n )
    end
end
