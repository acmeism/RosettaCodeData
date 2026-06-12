function isPrime( n )
    if n <= 1 or ( n ~= 2 and n % 2 == 0 ) then
        return false
    end

    for i = 3, math.sqrt(n), 2 do
        if n % i == 0 then
            return false
        end
    end

    return true
end

function reverseDigits( n )
    return tonumber( string.reverse( tostring( n ) ) )
end

do
    local pCount = 0
    local prev   = 0
    local curr   = 1
    while pCount < 10 do
        local nextF = prev + curr
        prev        = curr
        curr        = nextF
        local rev  = reverseDigits( curr )
        if isPrime( rev ) then
            pCount = pCount + 1
            io.write( " ", rev )
        end
    end
end
