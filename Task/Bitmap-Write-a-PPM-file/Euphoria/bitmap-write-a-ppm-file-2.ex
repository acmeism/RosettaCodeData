procedure write_ppm(sequence filename, sequence image)
    integer fn,dimx,dimy
    dimy = length(image[1])
    dimx = length(image)
    fn = open(filename,"wb")
    printf(fn, "P6\n%d %d\n255\n", {dimx,dimy})
    for y = 1 to dimy do
        for x = 1 to dimx do
            puts(fn, and_bits(image[x][y], {#FF0000,#FF00,#FF}) /
                                           {#010000,#0100,#01}) -- unpack color triple
        end for
    end for
    close(fn)
end procedure
