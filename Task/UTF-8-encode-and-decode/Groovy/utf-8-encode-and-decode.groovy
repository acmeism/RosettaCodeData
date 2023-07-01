import java.nio.charset.StandardCharsets

class UTF8EncodeDecode {
    static byte[] utf8encode(int codePoint) {
        char[] characters = [codePoint]
        new String(characters, 0, 1).getBytes StandardCharsets.UTF_8
    }

    static int utf8decode(byte[] bytes) {
        new String(bytes, StandardCharsets.UTF_8).codePointAt(0)
    }

    static void main(String[] args) {
        printf "%-7s %-43s %7s\t%s\t%7s%n", "Char", "Name", "Unicode", "UTF-8 encoded", "Decoded"

        ([0x0041, 0x00F6, 0x0416, 0x20AC, 0x1D11E]).each { int codePoint ->
            byte[] encoded = utf8encode codePoint
            Formatter formatter = new Formatter()
            encoded.each { byte b ->
                formatter.format "%02X ", b
            }
            String encodedHex = formatter.toString()
            int decoded = utf8decode encoded
            printf "%-7c %-43s U+%04X\t%-12s\tU+%04X%n", codePoint, Character.getName(codePoint), codePoint, encodedHex, decoded
        }
    }
}
