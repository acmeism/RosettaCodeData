import "std/math.zc"

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
    let a1: f64[2]  = [350.0, 10.0];
    let a2: f64[4]  = [90.0, 180.0, 270.0, 360.0];
    let a3: f64[3]  = [10.0, 20.0, 30.0];
    let aa: f64*[3] = [a1, a2, a3];
    let ls: int[3]  = [2, 4, 3];
    for i in 0..3 {
        let mean = mean_angle(aa[i], ls[i]);
        println "Mean for angles {i + 1} is : {mean:6.2f}";
    }
}
