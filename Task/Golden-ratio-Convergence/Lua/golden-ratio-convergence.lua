local phi, phi0, expected, iters = 1, 0, (1 + math.sqrt(5)) / 2, 0
repeat
    phi0, phi = phi, 1 + 1 / phi
    iters = iters + 1
until math.abs(phi0 - phi) < 1e-5
io.write( "after ", iters, " iterations, phi = ", phi )
io.write( ", expected value: ", expected, ", diff: ", math.abs( expected - phi ), "\n" )
