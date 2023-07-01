use std::env;

fn main() {
    let mut args = env::args().skip(1).flat_map(|num| num.parse());
    let rows = args.next().expect("Expected number of rows as first argument");
    let cols = args.next().expect("Expected number of columns as second argument");

    assert_ne!(rows, 0, "rows were zero");
    assert_ne!(cols, 0, "cols were zero");

    // Creates a vector of vectors with all elements initialized to 0.
    let mut v = vec![vec![0; cols]; rows];
    v[0][0] = 1;
    println!("{}", v[0][0]);
}
