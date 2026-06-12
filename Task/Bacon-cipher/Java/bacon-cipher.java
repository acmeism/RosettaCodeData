import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

public class BaconCipher {
    private static final Map<Character, String> codes;

    static {
        codes = new HashMap<>();
        codes.putAll(Map.of(
            'a', "AAAAA", 'b', "AAAAB", 'c', "AAABA", 'd', "AAABB", 'e', "AABAA",
            'f', "AABAB", 'g', "AABBA", 'h', "AABBB", 'i', "ABAAA", 'j', "ABAAB"
        ));
        codes.putAll(Map.of(
            'k', "ABABA", 'l', "ABABB", 'm', "ABBAA", 'n', "ABBAB", 'o', "ABBBA",
            'p', "ABBBB", 'q', "BAAAA", 'r', "BAAAB", 's', "BAABA", 't', "BAABB"
        ));
        codes.putAll(Map.of(
            'u', "BABAA", 'v', "BABAB", 'w', "BABBA", 'x', "BABBB", 'y', "BBAAA",
            'z', "BBAAB", ' ', "BBBAA" // use ' ' to denote any non-letter
        ));
    }

    private static String encode(String plainText, String message) {
        String pt = plainText.toLowerCase();
        StringBuilder sb = new StringBuilder();
        for (char c : pt.toCharArray()) {
            if ('a' <= c && c <= 'z') sb.append(codes.get(c));
            else sb.append(codes.get(' '));
        }
        String et = sb.toString();
        String mg = message.toLowerCase();  // 'A's to be in lower case, 'B's in upper case
        sb.setLength(0);
        int count = 0;
        for (char c : mg.toCharArray()) {
            if ('a' <= c && c <= 'z') {
                if (et.charAt(count) == 'A') sb.append(c);
                else sb.append(((char) (c - 32))); // upper case equivalent
                count++;
                if (count == et.length()) break;
            } else sb.append(c);
        }
        return sb.toString();
    }

    private static String decode(String message) {
        StringBuilder sb = new StringBuilder();
        for (char c : message.toCharArray()) {
            if ('a' <= c && c <= 'z') sb.append('A');
            if ('A' <= c && c <= 'Z') sb.append('B');
        }
        String et = sb.toString();
        sb.setLength(0);
        for (int i = 0; i < et.length(); i += 5) {
            String quintet = et.substring(i, i + 5);
            Character key = codes.entrySet().stream().filter(a -> Objects.equals(a.getValue(), quintet)).findFirst().map(Map.Entry::getKey).orElse(null);
            sb.append(key);
        }
        return sb.toString();
    }

    public static void main(String[] args) {
        String plainText = "the quick brown fox jumps over the lazy dog";
        String message = "bacon's cipher is a method of steganography created by francis bacon. " +
            "this task is to implement a program for encryption and decryption of " +
            "plaintext using the simple alphabet of the baconian cipher or some " +
            "other kind of representation of this alphabet (make anything signify anything). " +
            "the baconian alphabet may optionally be extended to encode all lower " +
            "case characters individually and/or adding a few punctuation characters " +
            "such as the space.";
        String cipherText = encode(plainText, message);
        System.out.printf("Cipher text ->\n\n%s\n", cipherText);
        String decodedText = decode(cipherText);
        System.out.printf("\nHidden text ->\n\n%s\n", decodedText);
    }
}
