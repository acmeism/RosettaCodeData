function drawline!(img::Matrix{T}, x0::Int, y0::Int, x1::Int, y1::Int, col::T) where T
    δx = abs(x1 - x0)
    δy = abs(y1 - y0)
    δe = abs(δy / δx)
    er = 0.0

    y = y0
    for x in x0:x1
        img[x, y] = col
        er += δe
        if er > 0.5
            y  += 1
            er -= 1.0
        end
    end

    return img
end

using Images

img = fill(Gray(255.0), 5, 5);
println("\nImage:")
display(img); println()
drawline!(img, 1, 1, 5, 5, Gray(0.0));
println("\nModified image:")
display(img); println()
