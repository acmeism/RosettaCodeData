# Three Word Location - convert latitude and longitude to three words
LAT = 28.3852
LON = -81.5638

# build word array W00000 ... W28125
wordarray = ["W" * string(x, pad=5) for x in 0:28125]

# make latitude and longitude positive integers
ILAT = Int(LAT * 10000 + 900000)
ILON = Int(LON * 10000 + 1800000)

# build 43 bit integer containing latitude (21 bits) and longitude (22 bits)
LATLON = (ILAT << 22) + ILON

# isolate most significant 15 bits for word 1 index
# next 14 bits for word 2 index
# next 14 bits for word 3 index
W1 = (LATLON >> 28) & 0x7fff
W2 = (LATLON >> 14) & 0x3fff
W3 = LATLON & 0x3fff

# fetch each word from word array
w1 = wordarray[W1 + 1]
w2 = wordarray[W2 + 1]
w3 = wordarray[W3 + 1]

# display words
println("$w1 $w2 $w3")


# reverse the procedure

# look up each word
(w1index, w2index, w3index) = indexin([w1, w2, w3], wordarray) .- 1

# build the latlon integer from the word indexes
latlon = (w1index << 28) | (w2index << 14) | w3index


# isolate the latitude and longitude
ilon =  latlon & 0xfffff
ilat = latlon >> 22

# convert back to floating point values
lon = (ilon - 1800000) / 10000
lat = (ilat - 900000) / 10000

# display values
println("latitude = $lat longitude = $lon")
