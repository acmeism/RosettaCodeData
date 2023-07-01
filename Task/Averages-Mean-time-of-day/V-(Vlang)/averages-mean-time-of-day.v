import math

const inputs = ["23:00:17", "23:40:20", "00:12:45", "00:17:19"]

fn main() {
    angles := inputs.map(time_to_degs(it))
    println('Mean time of day is: ${degs_to_time(mean_angle(angles))}')
}
fn mean_angle(angles []f64) f64 {
    n := angles.len
    mut sin_sum := f64(0)
    mut cos_sum := f64(0)
    for angle in angles {
        sin_sum += math.sin(angle * math.pi / 180)
        cos_sum += math.cos(angle * math.pi / 180)
    }
    return math.atan2(sin_sum/n, cos_sum/n) * 180 / math.pi
}

fn degs_to_time(dd f64) string{
    mut d := dd
    for d < 0 {
        d += 360
    }
    mut s := math.round(d * 240)
    h := math.floor(s/3600)
    mut m := math.fmod(s, 3600)
    s = math.fmod(m, 60)
    m = math.floor(m / 60)
    return "${h:02}:${m:02}:${s:02}"
}

fn time_to_degs(time string) f64 {
    t := time.split(":")
    h := t[0].f64() * 3600
    m := t[1].f64() * 60
    s := t[2].f64()
    return (h + m + s) / 240
}
