const nondecimal = "abcdef"
fn main() {
	mut c := 0
	for i := i64(0); i <= 500; i++ {
		hex := i.hex()
		if nondecimal.contains_any(hex) {
			print('${i:3d} ')
			c++
			if c % 15 == 0 {
				println('')
			}
		}
	}
	println('\n\n$c such numbers found.\n')
}
