import encoding.base64

fn main() {
    msg := "Rosetta Code Base64 decode data task"
    println("Original : $msg")
    encoded := base64.encode_str(msg)
    println("\nEncoded  : $encoded")
    decoded := base64.decode_str(encoded)
    println("\nDecoded  : $decoded")
}
