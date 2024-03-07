import "./crypto" for Md5
import "./fmt" for Fmt

var strings = [
    "The quick brown fox jumps over the lazy dog",
    "The quick brown fox jumps over the lazy dog.",
    ""
]

for (s in strings) {
    var digest = Md5.digest(s)
    Fmt.print("$s <== '$0s'", digest, s)
}
