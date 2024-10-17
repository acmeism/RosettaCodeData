using Images, FileIO

ima = load("data/lenna50.jpg")
imb = Gray.(ima)

medcol = median(imb)
imb[imb .≤ medcol] = Gray(0.0)
imb[imb .> medcol] = Gray(1.0)
save("data/lennaGray.jpg", imb)
