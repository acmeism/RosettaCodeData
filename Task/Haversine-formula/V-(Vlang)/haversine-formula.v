import math

fn haversine(h f64) f64 {
    return .5 * (1 - math.cos(h))
}

struct Pos {
    lat f64 // latitude, radians
    long f64 // longitude, radians
}

fn deg_pos(lat f64, lon f64) Pos {
    return Pos{lat * math.pi / 180, lon * math.pi / 180}
}

const r_earth = 6372.8 // km

fn hs_dist(p1 Pos, p2 Pos) f64 {
    return 2 * r_earth * math.asin(math.sqrt(haversine(p2.lat-p1.lat)+
        math.cos(p1.lat)*math.cos(p2.lat)*haversine(p2.long-p1.long)))
}

fn main() {
    println(hs_dist(deg_pos(36.12, -86.67), deg_pos(33.94, -118.40)))
}
