import "std/mem.zc"

fn main() {
    let a = 1;
    let b = 2;
    println "Before: a = {a}, b = {b}";
    swap(&a, &b);
    println "After : a = {a}, b = {b}";
    println "";
    let s = "Rosetta";
    let t = "Code";
    println "Before: s = {s}, t = {t}";
    swap(&s, &t);
    println "After : s = {s}, t = {t}";
}
