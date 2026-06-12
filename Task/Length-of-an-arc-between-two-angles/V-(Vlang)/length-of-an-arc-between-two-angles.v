import math

fn arc_length(radius f64, angle1 f64, angle2 f64) f64 {
    return (360 - math.abs(angle2-angle1)) * math.pi * radius/180
}
fn main() {
    println(arc_length(10, 10, 120))
}
