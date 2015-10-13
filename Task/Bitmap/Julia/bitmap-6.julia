function showpixel(a::Image, x::Int, y::Int)
    c = color(a, x, y)
    hex(c.r, 2)*hex(c.g, 2)*hex(c.b, 2)
end

w = 5
h = 7
a = Image(w, h)

purple = Color(0xff, 0, 0xff)
green = Color(0, 0xff, 0)

fill!(a, purple)
splat!(a, 2, 3, green)

for i in 1:h
    for j in 1:w
        print(showpixel(a, j, i), " ")
    end
    println()
end
