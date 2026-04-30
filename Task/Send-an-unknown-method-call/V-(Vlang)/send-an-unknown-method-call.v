import os

struct Obj {
    mut:
    methods map[string]fn()
}

fn (mut o Obj) create_methods() Obj {
    o.methods["ma"] = fn () { println("Method A Called") }
    o.methods["mb"] = fn () { println("Method B Called") }
    o.methods["mc"] = fn () { println("Method C Called") }
    return o
}

fn main() {
    mut obj := Obj{}
    obj = obj.create_methods()
    name := os.input("Which method should I call? ").str()
    if name in obj.methods { obj.methods[name]() }
    else { println("No method of that name found!") }
}
