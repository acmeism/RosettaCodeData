/* imports */
import "core:fmt"
import "core:strings"
import "core:math/rand"
/* globals */
cylinder := [6]bool{}
/* main block */
main :: proc() {
	rand.set_global_seed(42)
	tests := 100000
	sequence := [?]string{"LSLSFSF", "LSLSFF", "LLSFSF", "LLSFF"}
	for m in sequence {
		sum := 0
		for t in 0 ..< tests {
			sum += method(m)
		}
		pc: f64 = cast(f64)sum * 100 / cast(f64)tests
		fmt.printf("%-40s produces %6.3f%% deaths.\n", mstring(m), pc)
	}
}
/* definitions */
rshift :: proc() {
	t := cylinder[len(cylinder) - 1]
	copy(cylinder[1:], cylinder[0:])
	cylinder[0] = t
}
unload :: proc() {
	cylinder = false // array programming
}
load :: proc() {
	for cylinder[0] {
		rshift()
	}
	cylinder[0] = true
	rshift()
}
spin :: proc() {
	data: []int = {1, 2, 3, 4, 5, 6}
	lim := rand.choice(data[:])
	for i in 0 ..< lim {
		rshift()
	}
}
fire :: proc() -> bool {
	shot := cylinder[0]
	rshift()
	return shot
}
method :: proc(s: string) -> int {
	unload()
	for character in s {
		switch character {
		case 'L':
			load()
		case 'S':
			spin()
		case 'F':
			if fire() {
				return 1
			}
		}
	}
	return 0
}
mstring :: proc(s: string) -> string {
	l: [dynamic]string
	for character in s {
		switch character {
		case 'L':
			append(&l, "load")
		case 'S':
			append(&l, "spin")
		case 'F':
			append(&l, "fire")
		}
	}
	return strings.join(l[:], ", ")
}
