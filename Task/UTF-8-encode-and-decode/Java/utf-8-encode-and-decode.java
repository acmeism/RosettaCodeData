import java.nio.charset.StandardCharsets;
import java.util.Formatter;

public class UTF8EncodeDecode {

    public static byte[] utf8encode(int codepoint) {
        return new String(new int[]{codepoint}, 0, 1).getBytes(StandardCharsets.UTF_8);
    }

    public static int utf8decode(byte[] bytes) {
        return new String(bytes, StandardCharsets.UTF_8).codePointAt(0);
    }

    public static void main(String[] args) {
        System.out.printf("%-7s %-43s %7s\t%s\t%7s%n",
                "Char", "Name", "Unicode", "UTF-8 encoded", "Decoded");

        for (int codepoint : new int[]{0x0041, 0x00F6, 0x0416, 0x20AC, 0x1D11E}) {
            byte[] encoded = utf8encode(codepoint);
            Formatter formatter = new Formatter();
            for (byte b : encoded) {
                formatter.format("%02X ", b);
            }
            String encodedHex = formatter.toString();
            int decoded = utf8decode(encoded);
            System.out.printf("%-7c %-43s U+%04X\t%-12s\tU+%04X%n",
                    codepoint, Character.getName(codepoint), codepoint, encodedHex, decoded);
        }
    }
}
