fn main() {
    for let i = 1; ; ++i {
        let j = i - 1;
        if i * i - j * j > 1000 {
            println "{i}";
            break;
        }
    }
}
