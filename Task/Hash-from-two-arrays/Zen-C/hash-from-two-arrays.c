import "std/map.zc"

fn main() {
    let keys = ["1", "2", "3", "4", "5"];
    let values = ["first", "second", "third", "fourth","fifth"];
    let hash = Map<string>::new();
    for i in 0..5 { hash.put(keys[i], values[i]); }
    for entry in hash {
        print "{{{entry.key}: {entry.val}}}, ";
    }
    println "\b\b ";
}
