import math

fn main() {
    c, f, r := kelvin_to_cfr(21)
    println('Celsius: $c˚\nFahrenheit: $f˚\nRankine: $r˚')
}

fn kelvin_to_cfr(kelvin f64) (string, string, string) {
    celsius := math.round_sig(kelvin - 273.15, 2)
    fahrenheit := math.round_sig(kelvin * 1.8 - 459.67, 2)
    rankine := math.round_sig(kelvin * 1.8, 2)
    return celsius.str(), fahrenheit.str(), rankine.str()
}
