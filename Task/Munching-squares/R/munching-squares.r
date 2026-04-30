mat <- outer(0:255, 0:255, bitwXor)
png(filename="MunchingSquares-R.png", width=1000, height=1000)
image(mat, axes=FALSE)
dev.off()
