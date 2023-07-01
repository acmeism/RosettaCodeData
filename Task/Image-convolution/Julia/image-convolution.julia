using FileIO, Images

img = load("image.jpg")

sharpenkernel = reshape([-1.0, -1.0, -1.0, -1.0,  9.0, -1.0, -1.0, -1.0, -1.0], (3,3))

imfilt = imfilter(img, sharpenkernel)

save("imagesharper.png", imfilt)
