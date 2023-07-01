import java.util.Base64

object Base64Decode extends App {

  def text2BinaryDecoding(encoded: String): String = {
    val decoded = Base64.getDecoder.decode(encoded)
    new String(decoded, "UTF-8")
  }

  def data =
    "VG8gZXJyIGlzIGh1bWFuLCBidXQgdG8gcmVhbGx5IGZvdWwgdGhpbmdzIHVwIHlvdSBuZWVkIGEgY29tcHV0ZXIuCiAgICAtLSBQYXVsIFIuIEVocmxpY2g="

  println(text2BinaryDecoding(data))
}
