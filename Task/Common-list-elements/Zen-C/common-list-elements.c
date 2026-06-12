import "std/vec.zc"

fn intersection(a: Vec<int>*, b: Vec<int>*) -> Vec<int> {
    let res = Vec<int>::new();
    for e in *a {
        if b.contains(e) { res << e; }
    }
    return res;
}

fn main() {
    let a1 = [2, 5, 1, 3, 8, 9, 4, 6];
    let a2 = [3, 5, 6, 2, 9, 8, 4];
    let a3 = [1, 3, 7, 6, 9];
    let v1 = Vec<int>::new();
    let v2 = Vec<int>::new();
    let v3 = Vec<int>::new();
    for e in a1 { v1 << e; }
    for e in a2 { v2 << e; }
    for e in a3 { v3 << e; }
    let inter1 = intersection(&v1, &v2);
    let inter2 = intersection(&inter1, &v3);
    print "[";
    for v in inter2 { print "{v}, "; }
    println "\b\b]";
}
