package main

import (
    "fmt"
    "strings"
)

type Location struct{ lat, lng float64 }

func (loc Location) String() string { return fmt.Sprintf("[%f, %f]", loc.lat, loc.lng) }

type Range struct{ lower, upper float64 }

var gBase32 = "0123456789bcdefghjkmnpqrstuvwxyz"

func encodeGeohash(loc Location, prec int) string {
    latRange := Range{-90, 90}
    lngRange := Range{-180, 180}
    var hash strings.Builder
    hashVal := 0
    bits := 0
    even := true
    for hash.Len() < prec {
        val := loc.lat
        rng := latRange
        if even {
            val = loc.lng
            rng = lngRange
        }
        mid := (rng.lower + rng.upper) / 2
        if val > mid {
            hashVal = (hashVal << 1) + 1
            rng = Range{mid, rng.upper}
            if even {
                lngRange = Range{mid, lngRange.upper}
            } else {
                latRange = Range{mid, latRange.upper}
            }
        } else {
            hashVal <<= 1
            if even {
                lngRange = Range{lngRange.lower, mid}
            } else {
                latRange = Range{latRange.lower, mid}
            }
        }
        even = !even
        if bits < 4 {
            bits++
        } else {
            bits = 0
            hash.WriteByte(gBase32[hashVal])
            hashVal = 0
        }
    }
    return hash.String()
}

func main() {
    locs := []Location{
        {51.433718, -0.214126},
        {51.433718, -0.214126},
        {57.64911, 10.40744},
    }
    precs := []int{2, 9, 11}

    for i, loc := range locs {
        geohash := encodeGeohash(loc, precs[i])
        fmt.Printf("geohash for %v, precision %-2d = %s\n", loc, precs[i], geohash)
    }
}
