struct Animal {
	mut:
    alive bool
}

struct Dog {
    Animal
	mut:
    obediant bool
}

struct Cat {
    Animal
	mut:
    trained bool
}

struct Lab {
    Dog
	mut:
    color string
}

struct Collie {
    Dog
	mut:
    catches bool
}

fn main() {
    mut pet := Lab{}
    pet.alive = true
    pet.obediant = false
    pet.color = "black"
	println(pet)
}
