using Printf

const sides = 5
const order = 5
const dim   = 250
const scale = (3 - order ^ 0.5) / 2
const τ = 8 * atan(1, 1)
const orders = map(x -> ((1 - scale) * dim) * scale ^ x, 0:order-1)
cis(x) = Complex(cos(x), sin(x))
const vertices = map(x -> cis(x * τ  / sides), 0:sides-1)

fh = open("sierpinski_pentagon.svg", "w")
print(fh, """<svg height=\"$(dim*2)\" width=\"$(dim*2)\" style=\"fill:blue\" """ *
    """version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\">\n""")

for i in 1:sides^order
    varr = [vertices[parse(Int, ch) + 1] for ch in split(string(i, base=sides, pad=order), "")]
    vector = sum(map(x -> varr[x] * orders[x], 1:length(orders)))
    vprod = map(x -> vector + orders[end] * (1-scale) * x, vertices)

    points = join([@sprintf("%.3f %.3f", real(v), imag(v)) for v in vprod], " ")
    print(fh, "<polygon points=\"$points\" transform=\"translate($dim,$dim) rotate(-18)\" />\n")
end

print(fh, "</svg>")
close(fh)
