fn main() {
    for i in 1..=10 {
        print "{i}";
        let s = i < 10 ? ", " : "\n"
        print "{s}"
    }
}
