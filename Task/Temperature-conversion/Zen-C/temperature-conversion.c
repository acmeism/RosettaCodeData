import "std/math.zc"

fn temp_conv(k: f64) {
    let c = k - 273.15;
    let f = c * 1.8 + 32.0;
    let r = f + 459.67;
    println "{k:7.2f}˚ Kelvin";
    println "{c:7.2f}˚ Celsius";
    println "{f:7.2f}˚ Fahrenheit";
    println "{r:7.2f}˚ Rankine";
    println "";
}

fn main() {
    let ks: f64[3] = [0.0, 21.0, 100.0];
    for k in ks { temp_conv(k); }
}
