use itertools::Itertools;

fn main() {
    print!("output string: ");
    for i in "gHHH5YY++///\\".split_duplicates().intersperse(", ") {
        print!("{i}");
    }
    println!();
}
