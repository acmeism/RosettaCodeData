fn show_type<T>(a T) {
    println('The type of $a is ${typeof(a).name}')
}

fn main() {
    show_type(-556461841)
    show_type('Rosetta')
    show_type(7.4)
    show_type(`s`)
    show_type([0x32,0x22])
}
