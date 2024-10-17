using Images, FileIO

img = load("data/bitmapOutputTest.jpg")
save("data/bitmapOutputTest.ppm", img)
