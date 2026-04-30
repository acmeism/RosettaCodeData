import rand

fn main() {
	mut values, mut rolls := [6]int{}, [4]int{}
	mut vsum , mut vcount, mut sum := 0, 0, 0
	for {
		for ir := 0; ir < 6; ir++ {
			for jir := 0; jir < 4; jir++ {
				rolls[jir] = 1 + rand.int_in_range(1, 6)!
			}
			rolls.sort()
			sum = 0
			for kir := 1; kir <= 3; kir++ {
				sum += rolls[4 - kir]
			}
			values[ir] = sum
		}
		for val in values { vsum += val }
		vcount = values.count(it >= 15)
		if vsum < 75 || vcount < 2 { continue }
		println("The 6 random numbers generated are: $values")
		println("Their sum is $vsum and $vcount of them are >= 15")
		break
	}
}
