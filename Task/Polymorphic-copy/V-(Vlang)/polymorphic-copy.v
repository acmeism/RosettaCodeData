interface Iden {
    identify() string
}

struct Tina {
    value f64
}

// structs can be embedded

struct Sara {
    tina Tina
    koan string
}

struct Ryan {
    tina Tina
    ch chan int
}

// methods assigned to structs

fn (x Tina) identify() string {
    return "I'm a Tina!"
}

fn (x Sara) identify() string {
    return "I'm a Sara!"
}

fn (x Ryan) identify() string {
    return x.tina.identify()
}

fn main() {
    // initialization of three variables with different types
    tina1 := Tina{5}
    sara1 := Sara{Tina{6}, "one"}
    ryan1 := Ryan{Tina{7}, chan int{}}

    // variables declared with the same interface type
    mut i1, mut i2, mut i3 := []Iden{}, []Iden{}, []Iden{}
    println("Initial (zero) values of interface variables:")
    println("i1: ${i1}")
    println("i2: ${i2}")
    println("i3: ${i3}")

    // i1, i2, and i3 have the static type of the interface, along with other different types.
    i1 << [tina1]; i2 << [sara1]; i3 << [ryan1] // semicolons can be used as optional separators in Vlang
    println("\nPolymorphic:")
    println("i1: ${i1} / ${i1[0].identify()} / ${typeof(i1[0]).name}\n")
    println("i2: ${i2} / ${i2[0].identify()} / ${typeof(i2[0]).name}\n")
    println("i3: ${i3} / ${i3[0].identify()} / ${typeof(i3[0]).name}\n")

     // copy: declare and assign in one step using "short declaration"
    i1c, i2c, i3c := i1, i2, i3

    // modify first set of polymorphic variables.
    i1, i2, i3 = [Sara{Tina{3}, "dog"}], [Ryan{Tina{1}, chan int{}}], [Tina{2}]

    println("\nFirst set now modified:")
    println("i1: ${i1} / ${i1[0].identify()} / ${typeof(i1).name}\n")
    println("i2: ${i2} / ${i2[0].identify()} / ${typeof(i2).name}\n")
    println("i3: ${i3} / ${i3[0].identify()} / ${typeof(i3).name}\n")

    println("\nCopies made before modifications:")
    println("i1c: ${i1c} / ${i1c[0].identify()} / ${typeof(i1c).name}\n")
    println("i2c: ${i2c} / ${i2c[0].identify()} / ${typeof(i2c).name}\n")
    println("i3c: ${i3c} / ${i3c[0].identify()} / ${typeof(i3c).name}\n")
}
