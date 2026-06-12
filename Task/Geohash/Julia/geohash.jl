const ch32 = "0123456789bcdefghjkmnpqrstuvwxyz"
const bool2ch = Dict(string(i-1, base=2, pad=5) => ch for (i, ch) in enumerate(ch32))
const ch2bool = Dict(v => k for (k, v) in bool2ch)

function bisect(val, mn, mx, bits)
    mid = (mn + mx) / 2
    if val < mid
        bits <<= 1                        # push 0
        mx = mid                          # range lower half
    else
        bits = (bits << 1) | 1            # push 1
        mn = mid                          # range upper half
    end
    return mn, mx, bits
end

function encoder(lat, lng, pre)
    latmin, latmax = -90, 90
    lngmin, lngmax = -180, 180
    bits = Int128(0)
    for i in 0:5*pre-1
        if i % 2 != 0
            # odd bit: bisect latitude
            latmin, latmax, bits = bisect(lat, latmin, latmax, bits)
        else
            # even bit: bisect longitude
            lngmin, lngmax, bits = bisect(lng, lngmin, lngmax, bits)
        end
    end
    # Bits to characters
    b = string(bits, base=2, pad=5*pre)
    geo = [bool2ch[b[i*5+1:i*5+5]] for i in 0:pre-1]
    return prod(geo)
end

function decoder(geo)
    minmaxes, latlong = [[-90.0, 90.0], [-180.0, 180.0]], 2
    for c in geo, bit in ch2bool[c]
        minmaxes[latlong][bit == '1' ? 1 : 2] = sum(minmaxes[latlong]) / 2
        latlong = 3 - latlong
    end
    return minmaxes
end

for ((lat, lng), pre) in [([51.433718, -0.214126],  2),
                          ([51.433718, -0.214126],  9),
                          ([57.64911,  10.40744] , 11),
                          ([57.64911,  10.40744] , 22)]
    encoded = encoder(lat, lng, pre)
    println("encoder(lat=$lat, lng=$lng, pre=$pre) = ", encoded)
    println("decoded = ", decoder(encoded))
end
