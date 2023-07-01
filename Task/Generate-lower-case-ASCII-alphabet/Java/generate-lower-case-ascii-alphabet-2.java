public class LowerAscii {

    public static void main(String[] args) {
        StringBuilder sb = new StringBuilder(26);
        for (char ch = 'a'; ch <= 'z'; ch++)
            sb.append(ch);
        System.out.printf("lower ascii: %s, length: %s", sb, sb.length());
    }
}
