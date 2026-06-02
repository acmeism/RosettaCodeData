import "std/vec.zc"

fn main() {
    let fruits = Vec<string>::new();
    fruits.push("apple");
    fruits.push("orange");

    // Retrieve the length using the built-in method
    let count = fruits.length();

    println "Vector length: {count}";
}
