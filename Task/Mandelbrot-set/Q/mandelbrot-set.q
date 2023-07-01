/adapted from https://www.linkedin.com/pulse/want-work-k-1010data-michal-wallace
q)s:{(.[-]x*x),2*prd x}            / complex square (x is R,Im pair)
q)m:{floor sqrt sum x*x}           / magnitude (distance from origin)
q)d: 120 60                        / dimensions of the picture
q)t: -88 -30                       / camera translation
q)f: reciprocal 40 20              / scale factor

q)c: (,/:\:) . f * t + til each d  / complex plane near mandelbrot set
q)z: d # enlist 0 0                / 3d array of zeroes in same shape
q)mb: c+ (s'')@					   / mandelbrot: s(z) + c
q)r: 1 _ 8 mb\z                    / collect 8 times

q)o: " 12345678"@ sum 2<m'''[r]    / "color" by how soon point "escapes"

q)-1 "\n"sv flip o;                / transpose and print the output
