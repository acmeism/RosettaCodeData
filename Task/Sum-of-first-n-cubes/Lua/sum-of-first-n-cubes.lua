do  -- show the sums of the cubes upto n for 0 <= n < 50
    local cubeSum = 0
    for n = 0, 49 do
        cubeSum = cubeSum + ( n * n * n )
        io.write( string.format( "%8d", cubeSum ) )
        if n % 10 == 9 then io.write( "\n" ) end
    end
end
