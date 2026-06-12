import strconv

fn to_word(w i64) string { return 'W${w:05}' }

fn from_word(ws string) i64 {
    u, _ := strconv.common_parse_uint2(ws[1..], 10, 64)
    return i64(u)
}

fn main() {
    println("Starting figures:")
    mut lat := 28.3852
    mut lon := -81.5638
    println("  latitude = ${lat:.4}, longitude = ${lon:.4}")

    // convert lat and lon to positive integers
    mut ilat := i64(lat*10000 + 900000)
    mut ilon := i64(lon*10000 + 1800000)

    // build 43 bit BigInt comprising 21 bits (lat) and 22 bits (lon)
    mut latlon := (ilat << 22) + ilon

    // isolate relevant bits
    mut w1 := (latlon >> 28) & 0x7fff
    mut w2 := (latlon >> 14) & 0x3fff
    mut w3 := latlon & 0x3fff

    // convert to word format
    w1s := to_word(w1)
    w2s := to_word(w2)
    w3s := to_word(w3)

    // and print the results
    println("\nThree word location is:")
    println("  $w1s $w2s $w3s")

    /* now reverse the procedure */
    w1 = from_word(w1s)
    w2 = from_word(w2s)
    w3 = from_word(w3s)

    latlon = (w1 << 28) | (w2 << 14) | w3
    ilat = latlon >> 22
    ilon = latlon & 0x3fffff
    lat = f64(ilat-900000) / 10000
    lon = f64(ilon-1800000) / 10000

    // and print the results
    println("\nAfter reversing the procedure:")
    println("  latitude = ${lat:.4}, longitude = ${lon:.4}")
}
