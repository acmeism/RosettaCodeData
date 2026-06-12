using Random

const LAT = 28.3852
const LON = -81.5638

# build word array W00000 ... W28125
const wordarray = ["W" * string(x, pad=5) for x in 0:28125]

function threewordencode(lat, lon, seed=0) # returns vector of 3 strings
    arr = wordarray
    if seed != 0
        rng = MersenneTwister(seed)
        arr = shuffle(rng, deepcopy(wordarray))
    end
    i = (Int(lat * 10000 + 900000) << 22) | Int(lon * 10000 + 1800000)
    return map(x -> arr[x + 1], [(i >> 28) & 0x7fff, (i >> 14) & 0x3fff, i & 0x3fff])
end

function threeworddecode(w1, w2, w3, seed=0) # returns pair of Float64
    arr = wordarray
    if seed != 0
        rng = MersenneTwister(seed)
        arr = shuffle(rng, deepcopy(wordarray))
    end
    (i1, i2, i3) = indexin([w1, w2, w3], arr) .- 1
    latlon = (i1 << 28) | (i2 << 14) | i3
    ilon, ilat = latlon & 0xfffff, latlon >> 22
    return  (ilon - 1800000) / 10000, (ilat - 900000) / 10000
end

words = threewordencode(LAT, LON)
println(join(words, " "))

lat, lon = threeworddecode(words...)
println("latitude = $lat longitude = $lon")

println("\nWith scramble using key 12345678:")
words = threewordencode(LAT, LON, 12345678)
println(join(words, " "))
lat, lon = threeworddecode(words..., 12345678)
println("latitude = $lat longitude = $lon")
