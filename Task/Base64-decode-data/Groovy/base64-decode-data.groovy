import java.nio.charset.StandardCharsets

class Decode {
    static void main(String[] args) {
        String data = "VG8gZXJyIGlzIGh1bWFuLCBidXQgdG8gcmVhbGx5IGZvdWwgdGhpbmdzIHVwIHlvdSBuZWVkIGEgY29tcHV0ZXIuCiAgICAtLSBQYXVsIFIuIEVocmxpY2g="
        Base64.Decoder decoder = Base64.getDecoder()
        byte[] decoded = decoder.decode(data)
        String decodedStr = new String(decoded, StandardCharsets.UTF_8)
        System.out.println(decodedStr)
    }
}
