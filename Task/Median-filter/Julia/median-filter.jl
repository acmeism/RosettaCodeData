using Images, ImageFiltering, FileIO
Base.isless(a::RGB{T}, b::RGB{T}) where T =
    red(a) < red(b) || green(a) < green(b) || blue(a) < blue(b)
Base.middle(x::RGB) = x

img = load("data/lenna100.jpg")
mapwindow(median!, img, (3, 3))
