using Images

function cubicbezier!(xy::Matrix,
                      img::Matrix = fill(RGB(255.0, 255.0, 255.0), 17, 17),
                      col::ColorTypes.Color = convert(eltype(img), Gray(0.0)),
                      n::Int = 20)
    t = collect(0:n) ./ n
    M = hcat((1 .- t) .^ 3, # a
             3t .* (1 .- t) .^ 2, # b
             3t .^ 2 .* (1 .- t), # c
             t .^ 3) # d
    p = floor.(Int, M * xy)
    for i in 1:n
        drawline!(img, p[i, :]..., p[i+1, :]..., col)
    end
    return img
end

xy = [16 1; 1 4; 3 16; 15 11]
cubicbezier!(xy)
