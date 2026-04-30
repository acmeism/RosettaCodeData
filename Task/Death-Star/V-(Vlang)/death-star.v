import math

enum Axis {
	x_
	y_
	z_
	r_
}

fn clamp(x f64, b f64, t f64) f64 {
	if x < b { return b }
	else if x > t { return t }
	else { return x }
}

fn dot(v []f64, w []f64) f64 {
	return v[int(Axis.x_)] * w[int(Axis.x_)] +
		v[int(Axis.y_)] * w[int(Axis.y_)] +
		v[int(Axis.z_)] * w[int(Axis.z_)]
}

fn normal(v []f64, mut result []f64) {
	ilen := 1.0 / f64(math.sqrt(dot(v, v)))
	result[int(Axis.x_)] = v[int(Axis.x_)] * ilen
	result[int(Axis.y_)] = v[int(Axis.y_)] * ilen
	result[int(Axis.z_)] = v[int(Axis.z_)] * ilen
}

fn hit_test(s []f64, x f64, y f64, mut result []f64) bool {
	mut z := s[int(Axis.r_)] * s[int(Axis.r_)] - (x - s[int(Axis.x_)]) * (x - s[int(Axis.x_)]) -
	(y - s[int(Axis.y_)]) * (y - s[int(Axis.y_)])
	if z >= 0 {
		z = math.sqrt(z)
		result[0] = s[int(Axis.z_)] - z
		result[1] = s[int(Axis.z_)] + z
		return true
	}
	else { return false }
}

fn death_star(posic []f64, neg []f64, sun []f64, k f64, amb f64) {
	mut xx, mut temp1, mut temp2 := []f64{len: 3}, []f64{len: 3}, []f64{len: 3}	
	mut hp, mut hn := []f64{len: 2}, []f64{len: 2}
	mut result_val, mut shade := 0, -1
	shades := [' ', '.', ':', '!', '*', 'o', 'e', '&', '#', '%', '@']	
	y_start := int(posic[int(Axis.y_)] - posic[int(Axis.r_)] - 0.5)
	y_end := int(posic[int(Axis.y_)] + posic[int(Axis.r_)] + 0.5)
	x_start := int(posic[int(Axis.x_)] - posic[int(Axis.r_)] - 0.5)
	x_end := int(posic[int(Axis.x_)] + posic[int(Axis.r_)] + 0.5)
	for y in y_start .. y_end + 1 {
		mut line := ''
		for x in x_start .. x_end + 1 {
			result_val = 0
			if !hit_test(posic, f64(x), f64(y), mut hp) { result_val = 0 }
			else if !hit_test(neg, f64(x), f64(y), mut hn) { result_val = 1 }
			else if hn[0] > hp[0] { result_val = 1 }
			else if hn[1] > hp[1] {	result_val = 0 }
			else if hn[1] > hp[0] {	result_val = 2 }
			else { result_val = 1 }
			shade = -1
			match result_val {
				0 {
					shade = 0
				}
				1 {
					temp1[int(Axis.x_)] = f64(x) - posic[int(Axis.x_)]
					temp1[int(Axis.y_)] = f64(y) - posic[int(Axis.y_)]
					temp1[int(Axis.z_)] = hp[0] - posic[int(Axis.z_)]
					normal(temp1, mut xx)
				}
				2 {
					temp2[int(Axis.x_)] = neg[int(Axis.x_)] - f64(x)
					temp2[int(Axis.y_)] = neg[int(Axis.y_)] - f64(y)
					temp2[int(Axis.z_)] = neg[int(Axis.z_)] - hn[1]
					normal(temp2, mut xx)
				}
				else {}
			}

			if shade != 0 {
				b := math.pow(dot(sun, xx), k) + amb
				shade = int(clamp((1.0 - b) * f64(shades.len - 1), 1, f64(shades.len - 1)))
			}
			line += shades[shade].str()
		}
		println(line)
	}
}

fn main() {
	mut posic, mut neg := []f64{len: 4},  []f64{len: 4}
	mut temp3, mut sun := []f64{len: 3}, []f64{len: 3}
	posic[int(Axis.x_)] = 20
	posic[int(Axis.y_)] = 20
	posic[int(Axis.z_)] = 0
	posic[int(Axis.r_)] = 20
	neg[int(Axis.x_)] = 10
	neg[int(Axis.y_)] = 10
	neg[int(Axis.z_)] = -15
	neg[int(Axis.r_)] = 10
	temp3[0] = -2
	temp3[1] = 1
	temp3[2] = 3
	normal(temp3, mut sun)
	death_star(posic, neg, sun, 2, 0.1)
}
