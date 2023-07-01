import hash.crc32

fn main() {
    text := "The quick brown fox jumps over the lazy dog"
    result := crc32.sum(text.bytes())
    println(result.hex())
}
