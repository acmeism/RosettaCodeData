constant dimx = 800, dimy = 800
constant fn = open("first.ppm","wb") -- b - binary mode
sequence color
printf(fn, "P6\n%d %d\n255\n", {dimx,dimy})
for j = 0 to dimy-1 do
    for i = 0 to dimx-1 do
        color = {
            remainder(i,256), -- red
            remainder(j,256), -- green
            remainder(i*j,256) -- blue
        }
        puts(fn,color)
    end for
end for
close(fn)
