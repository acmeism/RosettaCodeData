do  -- find primes whose reversed digits are also prime
    local function isPrime( p )
        if p <= 1 or p % 2 == 0 then
            return p == 2
        else
            local prime = true
            local i     = 3
            local rootP = math.floor( math.sqrt( p ) )
            while i <= rootP and prime do
                prime = p % i ~= 0
                i     = i + 2
            end
            return prime
        end
    end
    local function reverseDigits( n )
        return tonumber( string.reverse( tostring( n ) ) )
    end
    local count = 0
    for n = 1,500 do
        if isPrime( n ) then
            if isPrime( reverseDigits( n ) ) then
                count = count + 1
                io.write( string.format( "%3d", n ), count % 10 == 0 and "\n" or " " )
            end
        end
    end
    io.write( "\nFound ", count, " reversable primes up to 500" )
end
