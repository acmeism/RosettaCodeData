h = [-8, -9, -3, -1, -6, 7]
g = [24, 75, 71, -34, 3, 22, -45, 23, 245, 25, 52, 25, -67, -96, 96, 31, 55, 36, 29, -43, -7]
f = [-3, -6, -1, 8, -6, 3, -1, -9, -9, 3, -2, 5, 2, -2, -7, -1]

hanswer = deconv(float.(g), float.(f))
println("The deconvolution deconv(g, f) is $hanswer, which is the same as h = $h\n")

fanswer = deconv(float.(g), float.(h))
println("The deconvolution deconv(g, h) is $fanswer, which is the same as f = $f\n")
