fn forward_diff(a: int*, ac: int, order: const uint) {
    if ac == 0 || order == 0 { return; }
    for o in 0..=order {
        print "{o:2u}: ";
        for i in 0..ac {
            print "{a[i]:5d} ";
            if i == ac - 1 { break; }
            a[i] = a[i + 1] - a[i];
        }
        println "";
        if !(--ac) { return; }
    }
}

fn main() {
    let a = [90, 47, 58, 29, 22, 32, 55, 5, 55, 73];
    forward_diff(a, 10, 9);
}
