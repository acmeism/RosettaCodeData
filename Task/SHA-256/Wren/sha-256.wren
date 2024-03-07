import "./crypto" for Sha256
import "./fmt" for Fmt

var strings = [
    "",
    "a",
    "abc",
    "message digest",
    "abcdefghijklmnopqrstuvwxyz",
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
    "12345678901234567890123456789012345678901234567890123456789012345678901234567890",
    "The quick brown fox jumps over the lazy dog",
    "The quick brown fox jumps over the lazy cog",
    "Rosetta code"
]

for (s in strings) {
    var hash = Sha256.digest(s)
    Fmt.print("$s <== '$0s'", hash, s)
}
