alias clos = fn() -> int;

fn main() {
    let fs: [clos; 10];
    for i in 0..10 {
        fs[i] = fn() -> int { return i * i; }
    }
    for i in 0..9 {
        println "Function {i} : {fs[i]()}";
    }
}
