import math
type Bearing = f64

const test_cases = [
    [Bearing(20), 45],
    [Bearing(-45), 45],
    [Bearing(-85), 90],
    [Bearing(-95), 90],
    [Bearing(-45), 125],
    [Bearing(-45), 145],
    [Bearing(29.4803), -88.6381],
    [Bearing(-78.3251), -159.036],
]

fn main() {
    for tc in test_cases {
        println(tc[1].sub(tc[0]))
        println(angle_difference(tc[1],tc[0]))
    }
}

fn (b2 Bearing) sub(b1 Bearing) Bearing {
    d := b2 - b1
    match true {
        d < -180 {
            return d + 360
        }
        d > 180 {
            return d - 360
        }
        else {
            return d
        }
    }
}
fn angle_difference(b2 Bearing, b1 Bearing) Bearing {
    return math.mod(math.mod(b2-b1, 360)+360+180, 360) - 180
}
