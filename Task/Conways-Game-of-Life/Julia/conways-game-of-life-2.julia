using ArrayFire
using Images
using LinearAlgebra

const blinker = [0 0 0; 1 1 1; 0 0 0]
const glider = [0 0 1; 1 0 1; 0 1 1]
const lwss = [0 1 1 1 1; 1 0 0 0 1; 0 0 0 0 1; 1 0 0 1 0]
const glidergun = [
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0;
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0;
  0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0;
  0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0;
  0 1 1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
  0 1 1 0 0 0 0 0 0 0 0 1 0 0 0 1 0 1 1 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0;
  0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0;
  0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
  0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]

function lifegame(fname, initializer, mapsize=30, imgsteps=50, upscaleratio=20)
    kernel = convert(Array{Float32}, [1 1 1; 1 0 1; 1 1 1]) |> AFArray
    initialstate = zeros(Bool, mapsize, mapsize)
    mid = div(mapsize, 2)
    (xlen, ylen), (halfx, halfy) = size(initializer), div.(size(initializer), 2)
    x1, x2 = mid - halfx, isodd(xlen) ? mid + halfx : mid + halfx - 1
    y1, y2 = mid - halfy, isodd(ylen) ? mid + halfy : mid + halfy - 1
    initialstate[x1:x2, y1:y2] .= initializer
    state = initialstate .+ Float32(.0) |> AFArray
    img = zeros(Float32, mapsize * upscaleratio, mapsize * upscaleratio, imgsteps)
    for i in 1:imgsteps
        nb = convolve2(state, kernel, UInt32(0), UInt32(0))
        a = (nb == 2)
        b = (nb == 3)
        state = ((state .* a .+ b) > 0) + Float32(0)
        frame = imresize(state, ratio=upscaleratio)
        img[:, :, i] .= frame
    end
    save(fname, img)
end

lifegame("blinker.gif", blinker)
lifegame("glider.gif", glider)
lifegame("lwss.gif", lwss)
lifegame("glidergun.gif", glidergun, 90, 200)
