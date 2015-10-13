w = 500
h = 300
a = Image(w, h)

purple = Color(0xff, 0, 0xff)
green = Color(0, 0xff, 0)
white = Color(0xff, 0xff, 0xff)

fill!(a, green)
for i in 20:220, j in 10:100
    splat!(a, i, j, purple)
end
for i in 180:400, j in 80:200
    splat!(a, i, j, white)
end

fn = "bitmap_write.ppm"
writeppm(fn, a)
