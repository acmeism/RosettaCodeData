ch32 = "0123456789bcdefghjkmnpqrstuvwxyz"
bool2ch = {f"{i:05b}": ch for i, ch in enumerate(ch32)}
ch2bool = {v : k for k, v in bool2ch.items()}

def bisect(val, mn, mx, bits):
    mid = (mn + mx) / 2
    if val < mid:
        bits <<= 1                        # push 0
        mx = mid                          # range lower half
    else:
        bits = bits << 1 | 1              # push 1
        mn = mid                          # range upper half

    return mn, mx, bits

def encoder(lat, lng, pre):
    latmin, latmax = -90, 90
    lngmin, lngmax = -180, 180
    bits = 0
    for i in range(pre * 5):
        if i % 2:
            # odd bit: bisect latitude
            latmin, latmax, bits = bisect(lat, latmin, latmax, bits)
        else:
            # even bit: bisect longitude
            lngmin, lngmax, bits = bisect(lng, lngmin, lngmax, bits)
    # Bits to characters
    b = f"{bits:0{pre * 5}b}"
    geo = (bool2ch[b[i*5: (i+1)*5]] for i in range(pre))

    return ''.join(geo)

def decoder(geo):
    minmaxes, latlong = [[-90.0, 90.0], [-180.0, 180.0]], True
    for c in geo:
        for bit in ch2bool[c]:
            minmaxes[latlong][bit != '1'] = sum(minmaxes[latlong]) / 2
            latlong = not latlong

    return minmaxes

if __name__ == '__main__':
    for (lat, lng), pre in [([51.433718, -0.214126],  2),
                            ([51.433718, -0.214126],  9),
                            ([57.64911,  10.40744] , 11),
                            ([57.64911,  10.40744] , 22)]:
        print("encoder(lat=%f, lng=%f, pre=%i) = %r"
              % (lat, lng, pre, encoder(lat, lng, pre)))
