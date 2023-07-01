using UnicodePlots

modifier(x) = (y = 2x - 1; y < 0 ? -y : y)
modrands(rands1, rands2) = [x for (i, x) in enumerate(rands1) if rands2[i] < modifier(x)]
histogram(modrands(rand(50000), rand(50000)), nbins = 20)
