interface Eatable {
    eat()
}

type Foodbox = []Eatable

type Peelfirst = string

fn (f Peelfirst) eat() {
    // peel code goes here
    println("mm, that ${f} was good!")
}

fn main() {
    mut fb := Foodbox{}
    fb << [Peelfirst("banana"), Peelfirst("mango")]
    // fb would print as `[Eatable(Peelfirst(banana)), Eatable(Peelfirst(mango))]`
    f0 := fb[0]
    f0.eat()
}
