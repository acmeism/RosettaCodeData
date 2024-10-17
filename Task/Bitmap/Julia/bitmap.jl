using Images, Colors

Base.hex(p::RGB{T}) where T = join(hex(c(p), 2) for c in (red, green, blue))
function showhex(m::Matrix{RGB{T}}, pad::Integer=4) where T
    for r in 1:size(m, 1)
        println(" " ^ pad, join(hex.(m[r, :]), " "))
    end
end

w, h = 5, 7
cback = RGB(1, 0, 1)
cfore = RGB(0, 1, 0)

img = Array{RGB{N0f8}}(h, w);
println("Uninitialized image:")
showhex(img)

fill!(img, cback)
println("\nImage filled with background color:")
showhex(img)

img[2, 3] = cfore
println("\nImage with a pixel set for foreground color:")
showhex(img)
