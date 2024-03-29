import math

fn main() {
	mut t, mut k1, mut k2, mut k3, mut k4, mut y := 0.0, 0.0, 0.0, 0.0, 0.0, 1.0
	for i in 0..101 {
		t = i  / 10.0
		if t == math.floor(t) {
			actual := math.pow((math.pow(t, 2) + 4), 2)/16
			println("y(${t:.0}) = ${y:.8f} error = ${(actual - y):.8f}")
		}
		k1 =  t * math.sqrt(y)
		k2 = (t + 0.05) * math.sqrt(y + 0.05 * k1)
		k3 = (t + 0.05) * math.sqrt(y + 0.05 * k2)
		k4 = (t + 0.10) * math.sqrt(y + 0.10 * k3)
		y += 0.1 * (k1 + 2 * (k2 + k3) + k4) / 6
	}
}
