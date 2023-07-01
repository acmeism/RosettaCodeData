fn main() {
    my_map := {
        "hello": 13,
        "world": 31,
        "!"    : 71 }

    // iterating over key-value pairs:
    for key, value in my_map {
        println("key = $key, value = $value")
    }

    // iterating over keys:
    for key,_ in my_map {
        println("key = $key")
    }

    // iterating over values:
    for _, value in my_map {
        println("value = $value")
    }
}
