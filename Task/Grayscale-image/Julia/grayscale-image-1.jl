using Color, Images, FixedPointNumbers

const M_RGB_Y = reshape(Color.M_RGB_XYZ[2,:], 3)

function rgb2gray(img::Image)
    g = red(img)*M_RGB_Y[1] + green(img)*M_RGB_Y[2] + blue(img)*M_RGB_Y[3]
    g = clamp(g, 0.0, 1.0)
    return grayim(g)
end

function gray2rgb(img::Image)
    colorspace(img) == "Gray" || return img
    g = map((x)->RGB{Ufixed8}(x, x, x), img.data)
    return Image(g, spatialorder=spatialorder(img))
end

ima = imread("grayscale_image_color.png")
imb = rgb2gray(ima)
imc = gray2rgb(imb)
imwrite(imc, "grayscale_image_rc.png")
