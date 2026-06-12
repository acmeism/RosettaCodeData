do
    local n = 0
    for i = 1,8 do
        local n3 = ( n * 10 ) + 3
        io.write( n3, " ", n3 * n3, "\n" )
        n = ( n * 10 ) + 1
    end
end
