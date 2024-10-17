using SHA

function merkletree(filename="title.png", blocksize=1024)
    bytes = codeunits(read(filename, String))
    len = length(bytes)
    hsh = [sha256(view(bytes. i:min(i+blocksize-1, len)])) for i in 1:1024:len]
    len = length(hsh)
    while len > 1
        hsh = [i == len ? hsh[i] : sha256(vcat(hsh[i], hsh[i + 1])) for i in 1:2:len]
        len = length(hsh)
    end
    return bytes2hex(hsh[1])
end

println(merkletree())
