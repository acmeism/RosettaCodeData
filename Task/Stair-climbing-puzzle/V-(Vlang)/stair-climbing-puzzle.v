import rand
import rand.seed

struct Walker {
	mut:
	position int
}

fn (mut wr Walker) step() bool {
	rm := rand.u32() > (max_u32 / 2)
	if rm {
		wr.position += 1
		println("Climbed up to ${wr.position}")
	} else {
		wr.position -= 1
		println("Fell down to ${wr.position}")
	}
	return rm
}

fn (mut wr Walker) step_up() {
    for !wr.step() {
    wr.step_up()
    }
}

fn main() {
	seeds := seed.time_seed_array(2)
	rand.seed(seeds)
	mut walker := Walker{0}
	walker.step_up()
}
