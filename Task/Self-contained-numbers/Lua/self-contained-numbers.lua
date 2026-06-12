do -- find some self-contained numbers: odd numbers whose Collatz sequence
   --      contains a multiple of the number itself

    local n, scCount = 3, 0
    while scCount < 7 do
        local v = n
        repeat
            v = ( 3 * v ) + 1
            while v & 1 == 0 do v = v >> 1 end
            if v % n == 0 then
                scCount = scCount + 1
                io.write( " ", n )
            end
        until v == 1
        n = n + 2
    end
end
