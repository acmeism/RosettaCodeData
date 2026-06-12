function toWord(w)
    return string.format("W%05d", w)
end

function fromWord(ws)
    return tonumber(string.sub(ws, 2, -1))
end

-------------------------------------------------------------------------

print("Starting figures:")
lat = 28.3852
lon = -81.5638
print(string.format("  latitude = %0.4f, longitude = %0.4f", lat, lon))
print()

-- convert from lat and lon to positive integers
ilat = lat * 10000 +  900000
ilon = lon * 10000 + 1800000

-- build 43 bit number comprising 21 bits (lat) and 22 bits (lon)
latlon = math.floor((ilat << 22) + ilon)

-- isloate relevant bits
w1 = (latlon >> 28) & 0x7fff
w2 = (latlon >> 14) & 0x3fff
w3 =  latlon        & 0x3fff

-- convert to word format
w1s = toWord(w1)
w2s = toWord(w2)
w3s = toWord(w3)

-- and print the results
print("Three word location is:")
print("  " .. w1s .. " " .. w2s .. " " .. w3s)
print()

-------------------------------------------------------------------------

-- now reverse the procedure
w1 = fromWord(w1s)
w2 = fromWord(w2s)
w3 = fromWord(w3s)

latlon = (w1 << 28) | (w2 << 14) | w3
ilat = latlon >> 22
ilon = latlon & 0x3fffff
lat = (ilat -  900000) / 10000
lon = (ilon - 1800000) / 10000

-- and print the results
print("After reversing the procedure:")
print(string.format("  latitude = %0.4f, longitude = %0.4f", lat, lon))
