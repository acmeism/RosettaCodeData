import "std/math.zc"

fn time_to_degs(time: string) -> f64 {
    let h = (10 * (time[0] - 48) + time[1] - 48) * 3600;
    let m = (10 * (time[3] - 48) + time[4] - 48) * 60;
    let s =  10 * (time[6] - 48) + time[7] - 48;
    return (f64)(h + m + s) / 240.0;
}

fn degs_to_time(d: f64, buf: char*) {
    while d < 0 { d += 360.0; }
    let s = (int)Math::round(d * 240.0);
    let h = (int)Math::floor(s / 3600.0);
    let m = s % 3600;
    s = m % 60;
    m /= 60;
    sprintf(buf, "%2d:%2d:%2d", h, m, s);
}

fn mean_angle(aa: f64*, n: const int) -> f64 {
    let sin_sum = 0.0;
    let cos_sum = 0.0;
    for i in 0..n {
        sin_sum += Math::sin(aa[i] * Math::PI() / 180.0);
        cos_sum += Math::cos(aa[i] * Math::PI() / 180.0);
    }
    return Math::atan2(sin_sum / n, cos_sum / n) * 180.0 / Math::PI();
}

fn main() {
    let times: string[4] = ["23:00:17", "23:40:20", "00:12:45", "00:17:19"];
    let angles: f64[4];
    for i in 0..4 {
        angles[i] = time_to_degs(times[i]);
    }
    let mean = mean_angle(angles, 4);
    let buf: char[9];
    degs_to_time(mean, buf);
    println "Mean time of day is : {buf}";
}
