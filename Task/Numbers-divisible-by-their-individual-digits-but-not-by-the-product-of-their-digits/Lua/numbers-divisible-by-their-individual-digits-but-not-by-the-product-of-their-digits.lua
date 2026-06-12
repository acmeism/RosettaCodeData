do  -- find numbers divisible by their digits but not the product of their digits

    local maxNumber <const> = 999

    local numberCount = 0
    for n = 1, maxNumber do
        local digitProduct, v, divisibleByDigits = 1, n, n ~= 0
        while divisibleByDigits and v > 0 do
            local digit = v % 10
            if digit == 0 then
                divisibleByDigits = false
            else
                divisibleByDigits = n % digit == 0
            end
            digitProduct  = digitProduct * digit
            v = v // 10
        end
        if divisibleByDigits and n % digitProduct ~= 0 then
            io.write( string.format( " %3d", n ) )
            numberCount = numberCount + 1
            if numberCount % 15 == 0 then io.write( "\n" ) end
        end
    end
end
