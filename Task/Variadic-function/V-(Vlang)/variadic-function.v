fn print_all(things ...string) {
    for val in things {
        print(val)
    }
}

fn main() {
    print_all("Mary ", "had ", "a ")
    print_all("little ", "lamb")
}
