import math

const number_doors = 101

fn main() {
    max_i := int(math.sqrt(f64(number_doors - 1))) + 1
    for i in 1..max_i {
        door := i * i
		println("Door ${door} open")
    }
}
