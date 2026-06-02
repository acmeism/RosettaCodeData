import "std/arena.zc"

fn main() {
    // Create an arena with 100 bytes capacity.
    let a = Arena::new(100);

    // Allocate an array of 8 32-bit integers i.e. 32 bytes.
    let arr = a.alloc_n<int>(8);
    for i in 0..8 {
        arr[i] = i + 1;
        print "{arr[i]} ";
    }
    println "";

    // Duplicate a C string into the arena.
    let s = a.dup_str("Rosetta Code"); // uses 13 bytes including final '\0'
    println "{s}";

    println "Arena has used     : {a.bytes_used()} bytes";
    println "Capacity remaining : {a.bytes_free()} bytes";
}
