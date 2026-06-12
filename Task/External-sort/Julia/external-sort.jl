intfile = open("/tmp/mmap.bin", "r+")

arr = Mmap.mmap(intfile, Vector{Int64}, (div(stat(intfile).size, 8))) # Int64 is 8 bytes

sort!(arr)
