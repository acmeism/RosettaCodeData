rmax = 2
nmax = 100
complex (x, y) = x * {1, 0} + y * {0, 1}
mandelbrot (z, z0, n) = n == nmax || abs (z) > rmax ? n : mandelbrot (z ** 2 + z0, z0, n + 1)
set samples 200
set isosamples 200
set pm3d map
set size square
splot [-2 : .8] [-1.4 : 1.4] mandelbrot (complex (0, 0), complex (x, y), 0) notitle
