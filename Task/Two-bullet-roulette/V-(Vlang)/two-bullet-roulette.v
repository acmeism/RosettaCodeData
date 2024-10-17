import rand

__global cylinder = []bool{len:6}

fn main() {
	test("LSLSFSF")
	test("LSLSFF")
	test("LLSFSF")
	test("LLSFF")
}

fn test(src string) {
	tests := 100000
	mut sum := 0
	for _ in 0..tests {
		sum += method(src)
	}
	println("${m_string(src)} produces ${100.0 * f32(sum) / f32(tests)}% deaths.")
}

fn rshift() {
	t := cylinder[5]
	for i := 4; i >= 0; i-- {
		cylinder[i+1] = cylinder[i]
	}
	cylinder[0] = t
}

fn unload() {
	for i := 0; i < 6; i++ {
		cylinder[i] = false
	}
}

fn load() {
	for cylinder[0] {
		rshift()
	}
	cylinder[0] = true
	rshift()
}

fn spin() {
	mut lim := 1 + rand.intn(6) or {exit(1)}
	for i := 1; i < lim; i++ {
		rshift()
	}
}

fn fire() bool {
	shot := cylinder[0]
	rshift()
	return shot
}

fn method(s string) int {
	unload()
	for c in s {
		match c.ascii_str() {
			'L' {load()}
			'S' {spin()}
			'F' {if fire() == true {return 1}}
			else {}
		}
	}
	return 0
}

fn m_string(s string) string {
	mut l := []string{}
	for c in s {
		match c.ascii_str() {
		   'L' {l << "load"}
		   'S' {l << "spin"}
		   'F' {l << "fire"}
		   else {}
		}
	}
	return l.join(", ")
}
