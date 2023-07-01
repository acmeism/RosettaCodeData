interface Beast {
    kind() string
    name() string
    cry() string
}

struct Dog {
    kind string
    name string
}

fn (d Dog) kind() string { return d.kind }

fn (d Dog) name() string { return d.name }

fn (d Dog) cry() string { return "Woof" }

struct Cat {
    kind string
    name string
}

fn (c Cat) kind() string { return c.kind }

fn (c Cat) name() string { return c.name }

fn (c Cat) cry() string { return "Meow" }

fn bprint(b Beast) {
    println("${b.name()}, who's a ${b.kind()}, cries: ${b.cry()}.")
}

fn main() {
    d := Dog{"labrador", "Max"}
    c := Cat{"siamese", "Sammy"}
    bprint(d)
    bprint(c)
}
