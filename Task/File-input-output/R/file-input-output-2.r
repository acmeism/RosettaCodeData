src <- file("input.txt", "rb")
dest <- file("output.txt", "wb")

while( length(v <- readBin(src, "raw")) > 0 ) {
  writeBin(v, dest)
}
close(src); close(dest)
