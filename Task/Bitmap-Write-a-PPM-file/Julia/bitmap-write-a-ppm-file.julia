using Images, FileIO

h, w = 50, 70
img = zeros(RGB{N0f8}, h, w)
img[10:40, 5:35] = colorant"skyblue"
for i in 26:50, j in (i-25):40
    img[i, j] = colorant"sienna1"
end

save("data/bitmapWrite.ppm", img)
save("data/bitmapWrite.png", img)
