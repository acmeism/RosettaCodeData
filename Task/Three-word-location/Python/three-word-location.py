def to_word(w: int):
    return "W%05d" % w

def from_word(ws: str):
    return int(ws[1:])

def main():
    print("Starting figures:")

    lat = 28.3852
    lon = -81.5638

    print(f" latitude = {lat:.4f}, longitude = {lon:.4f}")
    print()

    ilat = int(lat * 10000 + 900000)
    ilon = int(lon * 10000 + 1800000)

    latlon = (ilat << 22) + ilon

    w1 = (latlon >> 28) & 0x7fff
    w2 = (latlon >> 14) & 0x3fff
    w3 = latlon & 0x3fff

    w1s = to_word(w1)
    w2s = to_word(w2)
    w3s = to_word(w3)

    print("Three word location is: ")
    print(' ', w1s, w2s, w3s)
    print()

    w1 = from_word(w1s)
    w2 = from_word(w2s)
    w3 = from_word(w3s)

    latlon = (w1 << 28) | (w2 << 14) | w3
    ilat = latlon >> 22
    ilon = latlon & 0x3fffff

    lat = (ilat - 900000) / 10000
    lon = (ilon - 1800000) / 10000

    print("After reversing the procedure: ")
    print(f" latitude {lat:.4f}, longitude = {lon:.4f}")

if __name__ == '__main__':
    main()
