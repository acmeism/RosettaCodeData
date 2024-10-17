using Images, FileIO

ppmimg = load("data/bitmapInputTest.ppm")
save("data/bitmapOutputTest.jpg", ppmimg)
