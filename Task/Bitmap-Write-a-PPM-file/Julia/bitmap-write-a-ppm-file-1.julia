using Color, Images, FixedPointNumbers

w = 70
h = 50

a = zeros(RGB{Ufixed8}, h, w)
img = Image(a)

img["x", 10:40, "y", 5:35] = color("skyblue")
for i in 45:65, j in (i-25):40
    img["x", i, "y", j] = color("sienna1")
end

imwrite(img, "bitmap_write.ppm")
imwrite(img, "bitmap_write.png")
