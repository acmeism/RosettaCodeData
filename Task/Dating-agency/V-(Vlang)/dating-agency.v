const sailors = ['Adrian', 'Caspian', 'Dune', 'Finn', 'Fisher', 'Heron', 'Kai',
           'Ray', 'Sailor', 'Tao']

const ladies = ['Ariel', 'Bertha', 'Blue', 'Cali', 'Catalina', 'Gale', 'Hannah',
           'Isla', 'Marina', 'Shelly']

fn loves_a_sailor(lady string) bool {
	return lady[0] % 2 == 0
}

fn loves_a_lady(lady string, sailor string) bool {
	return lady[lady.len - 1] % 2 == sailor[sailor.len - 1] % 2
}

fn main() {
	for lady in ladies {
		if loves_a_sailor(lady) {
			println("Dating service should offer a date with ${lady}")
			for sailor in sailors {
				if loves_a_lady(lady, sailor) {
					println("  Sailor ${sailor}, should take an offer to date her.")
				}
			}
		}
		else {println("Dating service should NOT offer a date with ${lady}")}
	}
}
