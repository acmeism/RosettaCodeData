package main

func Inference(command uint32, bits byte, program [][2]uint32) (out uint64) {
	// Check if the program is empty
	if len(program) == 0 {
		return
	}

	// Iterate over the bits
	for j := byte(0); j < bits; j++ {
		var input = command | (uint32(j) << 16)
		var ss, maxx = program[0][0], program[0][1]
		input = Hash(input, ss, maxx)
		for i := 1; i < len(program); i++ {
			var s, max = program[i][0], program[i][1]
			maxx -= max
			input = Hash(input, s, maxx)
		}
		input &= 1
		if input != 0 {
			out |= 1 << j
		}
	}
	return
}

func Hash(n uint32, s uint32, max uint32) uint32 {
	// Mixing stage, mix input with salt using subtraction
	var m = n - s

	// Hashing stage, use xor shift with prime coefficients
	m ^= m << 2
	m ^= m << 3
	m ^= m >> 5
	m ^= m >> 7
	m ^= m << 11
	m ^= m << 13
	m ^= m >> 17
	m ^= m << 19

	// Mixing stage 2, mix input with salt using addition
	m += s

	// Modular stage using Lemire's fast alternative to modulo reduction
	return uint32((uint64(m) * uint64(max)) >> 32)
}

func main() {
	println(Inference(42, 64, [][2]uint32{{0, 2}}))
}
