fn a(foo: bool) -> bool {
    println!("a");
    foo
}

fn b(foo: bool) -> bool {
    println!("b");
    foo
}

fn main() {
    for i in vec![true, false] {
        for j in vec![true, false] {
            println!("{} and {} == {}", i, j, a(i) && b(j));
            println!("{} or {} == {}", i, j, a(i) || b(j));
            println!();
        }
    }
}
