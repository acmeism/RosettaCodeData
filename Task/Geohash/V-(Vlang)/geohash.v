struct Location {
    lat f64
    lng f64
}

fn (loc Location) str() string { return "[$loc.lat, $loc.lng]" }

struct Range {
    lower f64
    upper f64
}

const g_base32 = "0123456789bcdefghjkmnpqrstuvwxyz"

fn encode_geo_hash(loc Location, prec int) string {
    mut lat_range := Range{-90, 90}
    mut lng_range := Range{-180, 180}
    mut hash := ''
    mut hash_val := u32(0)
    mut bits := 0
    mut even := true
    for hash.len < prec {
        mut val := loc.lat
        mut rng := lat_range
        if even {
            val = loc.lng
            rng = lng_range
        }
        mid := (rng.lower + rng.upper) / 2
        if val > mid {
            hash_val = (hash_val << 1) + 1
            rng = Range{mid, rng.upper}
            if even {
                lng_range = Range{mid, lng_range.upper}
            } else {
                lat_range = Range{mid, lat_range.upper}
            }
        } else {
            hash_val <<= 1
            if even {
                lng_range = Range{lng_range.lower, mid}
            } else {
                lat_range = Range{lat_range.lower, mid}
            }
        }
        even = !even
        if bits < 4 {
            bits++
        } else {
            bits = 0
            hash+=g_base32[hash_val..hash_val+1]
            hash_val = u32(0)
        }
    }
    return hash.str()
}

fn main() {
    locs := [Location{51.433718, -0.214126},
        Location{51.433718, -0.214126},
        Location{57.64911, 10.40744},
    ]
    precs := [2, 9, 11]

    for i, loc in locs {
        geohash := encode_geo_hash(loc, precs[i])
        println("geohash for $loc, precision ${precs[i]:-2} = $geohash")
    }
}
