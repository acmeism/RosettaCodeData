import math

fn mean_angle(deg []f64) f64 {
	mut ss, mut sc := f64(0), f64(0)
	for x in deg {
		s, c := math.sincos(x * math.pi / 180)
		ss += s
		sc += c
	}
	return math.atan2(ss, sc) * 180 / math.pi
}

fn main() {
	for angles in [
		[f64(350), 10],
		[f64(90), 180, 270, 360],
		[f64(10), 20, 30],
	] {
		println("The mean angle of $angles is: ${mean_angle(angles)} degrees")
	}
}
