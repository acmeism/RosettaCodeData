using Color, Images, FixedPointNumbers

ima = imread("grayscale_image_color.png")
imb = convert(Image{Gray{Ufixed8}}, ima)
imwrite(imb, "grayscale_image_julia.png")
