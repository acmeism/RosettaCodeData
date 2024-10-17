import java.util.Base64

fun main() {
    val data =
        "VG8gZXJyIGlzIGh1bWFuLCBidXQgdG8gcmVhbGx5IGZvdWwgdGhpbmdzIHVwIHlvdSBuZWVkIGEgY29tcHV0ZXIuCiAgICAtLSBQYXVsIFIuIEVocmxpY2g="
    val decoder = Base64.getDecoder()
    val decoded = decoder.decode(data)
    val decodedStr = String(decoded, Charsets.UTF_8)
    println(decodedStr)
}
