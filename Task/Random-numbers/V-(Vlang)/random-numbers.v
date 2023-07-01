import crypto.rand

fn main() {
	mut nums := []u64{}
	for _ in 0..1000 {
		nums << rand.int_u64(10000) or {0} // returns random unsigned 64-bit integer from real OS source of entropy
	}
	println(nums)
}
