#![feature(iter_intersperse)]

fn main() {
    print!("output string: ");
    for i in "gHHH5YY++///\\".split_duplicates().intersperse(", ") {
        print!("{i}");
    }
    println!();
}
