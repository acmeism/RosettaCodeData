import rand
import os

fn main() {
	mut score, mut rnum := 0, 0
	mut mix, mut unmix := []int{}, []int{}
	for mix.len < 9 {
		rnum = rand.int_in_range(1, 10) or {println('Error: invalid number') exit(1)}
		if mix.contains(rnum) == false {
			mix << rnum
		}
	}
	unmix = mix.clone()
	unmix.sort()
	println("Select how many digits from the left to reverse.")
	for {
		print("The list is: ${mix} ==> How many digits to reverse? ")
		input := os.input('').str().trim_space().int()
		score++
		if input == 0 || input < 2 || input > 9 {
			println("\n(Enter a number from 2 to 9)")
			continue
		}
		for idx, rdx := 0, input - 1; idx < rdx; idx, rdx = idx + 1, rdx - 1 {
			mix[idx], mix[rdx] = mix[rdx], mix[idx]
		}
		if mix == unmix {
			println("The list is: ${mix}.")
			println("Your score: ${score}.  Good job.")
			break
		}
	}
}
