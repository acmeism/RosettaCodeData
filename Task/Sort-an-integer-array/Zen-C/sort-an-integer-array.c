import "std/sort.zc"

fn main() {
    let a = [7, 2, 4, 9, 1, 3, 8, 6, 5];
    sort_int((int*)a, 9);
    for i in a { print "{i} " }
    println "";
}
