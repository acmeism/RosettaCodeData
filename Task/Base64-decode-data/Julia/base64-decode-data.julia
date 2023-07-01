using Base64

io = IOBuffer()

iob64_decode = Base64DecodePipe(io)

write(io, "VG8gZXJyIGlzIGh1bWFuLCBidXQgdG8gcmVhbGx5IGZvdWwgdGhpbmdzIHVwIHlvdSBuZWVkIGEgY29tcHV0ZXIuCiAgICAtLVBhdWwgUi5FaHJsaWNo")

seekstart(io)

println(String(read(iob64_decode)))
