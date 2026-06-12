class BaconCipher {
    private static final Map<Character, String> codes

    static {
        codes = new HashMap<>()
        codes['a' as Character] = "AAAAA"
        codes['b' as Character] = "AAAAB"
        codes['c' as Character] = "AAABA"
        codes['d' as Character] = "AAABB"
        codes['e' as Character] = "AABAA"
        codes['f' as Character] = "AABAB"
        codes['g' as Character] = "AABBA"
        codes['h' as Character] = "AABBB"
        codes['i' as Character] = "ABAAA"
        codes['j' as Character] = "ABAAB"
        codes['k' as Character] = "ABABA"
        codes['l' as Character] = "ABABB"
        codes['m' as Character] = "ABBAA"
        codes['n' as Character] = "ABBAB"
        codes['o' as Character] = "ABBBA"
        codes['p' as Character] = "ABBBB"
        codes['q' as Character] = "BAAAA"
        codes['r' as Character] = "BAAAB"
        codes['s' as Character] = "BAABA"
        codes['t' as Character] = "BAABB"
        codes['u' as Character] = "BABAA"
        codes['v' as Character] = "BABAB"
        codes['w' as Character] = "BABBA"
        codes['x' as Character] = "BABBB"
        codes['y' as Character] = "BBAAA"
        codes['z' as Character] = "BBAAB"
        codes[' ' as Character] = "BBBAA"
    }

    private static String encode(String plainText, String message) {
        String pt = plainText.toLowerCase()
        StringBuilder sb = new StringBuilder()
        for (char c : pt.toCharArray()) {
            if (('a' as char) <= c && c <= ('z' as char)) sb.append(codes.get(c))
            else sb.append(codes.get(' ' as char))
        }
        String et = sb.toString()
        String mg = message.toLowerCase()  // 'A's to be in lower case, 'B's in upper case
        sb.setLength(0)
        int count = 0
        for (char c : mg.toCharArray()) {
            if (('a' as char) <= c && c <= ('z' as char)) {
                if (et.charAt(count) == ('A' as char)) sb.append(c)
                else sb.append((c - 32) as char) // upper case equivalent
                count++
                if (count == et.length()) break
            } else sb.append(c)
        }
        return sb.toString()
    }

    private static String decode(String message) {
        StringBuilder sb = new StringBuilder()
        for (char c : message.toCharArray()) {
            if (('a' as char) <= c && c <= ('z' as char)) sb.append('A')
            if (('A' as char) <= c && c <= ('Z' as char)) sb.append('B')
        }
        String et = sb.toString()
        sb.setLength(0)
        for (int i = 0; i < et.length(); i += 5) {
            def maxIdx = Math.min(i + 5, et.length())
            String quintet = et.substring(i, maxIdx)
            Character key = codes.entrySet().stream().filter({ a -> Objects.equals(a.getValue(), quintet) }).findFirst().map({ e -> e.getKey() }).orElse(null) as Character
            sb.append(key)
        }
        return sb.toString()
    }

    static void main(String[] args) {
        String plainText = "the quick brown fox jumps over the lazy dog"
        String message = "bacon's cipher is a method of steganography created by francis bacon. " +
                "this task is to implement a program for encryption and decryption of " +
                "plaintext using the simple alphabet of the baconian cipher or some " +
                "other kind of representation of this alphabet (make anything signify anything). " +
                "the baconian alphabet may optionally be extended to encode all lower " +
                "case characters individually and/or adding a few punctuation characters " +
                "such as the space."
        String cipherText = encode(plainText, message)
        System.out.printf("Cipher text ->\n\n%s\n", cipherText)
        String decodedText = decode(cipherText)
        System.out.printf("\nHidden text ->\n\n%s\n", decodedText)
    }
}
