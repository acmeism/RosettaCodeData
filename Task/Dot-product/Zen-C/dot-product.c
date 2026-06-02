fn dot_product(v1: [double], v2: [double]) -> double {
    if v1.len != v2.len {
        eprintln "Error: Vectors must have the same length (got {v1.len} and {v2.len})";
        return 0.0;
    }

    let sum = 0.0;
    for i in 0..v1.len {
        sum += (v1[i] * v2[i]);
    }
    return sum;
}

fn main() {
    let a: [double] = [1.0, 3.0, -5.0];
    let b: [double] = [4.0, -2.0, -1.0];

    let result = dot_product(a, b);

    println "Vector A: [1, 3, -5]";
    println "Vector B: [4, -2, -1]";
    println "A . B  = {result}";

    let a2: [double] = [1.0, 2.0, 3.0, 4.0];
    let b2: [double] = [0.5, 0.5, 0.5, 0.5];

    println "";
    println "Vector A2: [1, 2, 3, 4]";
    println "Vector B2: [0.5, 0.5, 0.5, 0.5]";
    println "A2 . B2 = {dot_product(a2, b2)}";
}
