using Color, Images, FixedPointNumbers

function hexify(pxl::RGB)
    p = reinterpret(Uint8, [pxl.r, pxl.g, pxl.b])
    join(map(x->hex(x, 2), p))
end

function showimagehex(a::Image)
    s = "    "
    for i in 1:height(a)
        for j in 1:width(a)
            s *= " "*hexify(a["x", j, "y", i])
        end
        s *= "\n    "
    end
    return s
end

w = 5
h = 7
cback = RGB(1, 0, 1)
cfore = RGB(0, 1, 0)

a = Array(RGB{Ufixed8}, h, w)
img = Image(a)

println("Uninitialized image:")
println(showimagehex(img))

fill!(img, cback)
println("Image filled with background color:")
println(showimagehex(img))

img["x", 2, "y", 3] = cfore
println("Image with a pixel set for foreground color:")
println(showimagehex(img))
