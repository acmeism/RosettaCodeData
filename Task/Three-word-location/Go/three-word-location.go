package main

import (
    "fmt"
    "strconv"
)

func toWord(w int64) string { return fmt.Sprintf("W%05d", w) }

func fromWord(ws string) int64 {
    var u, _ = strconv.ParseUint(ws[1:], 10, 64)
    return int64(u)
}

func main() {
    fmt.Println("Starting figures:")
    lat := 28.3852
    lon := -81.5638
    fmt.Printf("  latitude = %0.4f, longitude = %0.4f\n", lat, lon)

    // convert lat and lon to positive integers
    ilat := int64(lat*10000 + 900000)
    ilon := int64(lon*10000 + 1800000)

    // build 43 bit BigInt comprising 21 bits (lat) and 22 bits (lon)
    latlon := (ilat << 22) + ilon

    // isolate relevant bits
    w1 := (latlon >> 28) & 0x7fff
    w2 := (latlon >> 14) & 0x3fff
    w3 := latlon & 0x3fff

    // convert to word format
    w1s := toWord(w1)
    w2s := toWord(w2)
    w3s := toWord(w3)

    // and print the results
    fmt.Println("\nThree word location is:")
    fmt.Printf("  %s %s %s\n", w1s, w2s, w3s)

    /* now reverse the procedure */
    w1 = fromWord(w1s)
    w2 = fromWord(w2s)
    w3 = fromWord(w3s)

    latlon = (w1 << 28) | (w2 << 14) | w3
    ilat = latlon >> 22
    ilon = latlon & 0x3fffff
    lat = float64(ilat-900000) / 10000
    lon = float64(ilon-1800000) / 10000

    // and print the results
    fmt.Println("\nAfter reversing the procedure:")
    fmt.Printf("  latitude = %0.4f, longitude = %0.4f\n", lat, lon)
}
