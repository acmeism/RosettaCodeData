fn main() {
    let contents = std::fs::read("input.txt").expect("error reading input.txt");
    std::fs::write("output.txt", contents).expect("error writing output.txt");
}
