import "std/vec.zc";

fn main() {
    let vec = Vec<int>::new();
    vec << 1;
    vec << 2;
    vec << 3;
    for v in vec { println "{v}"; }
}
