import java.util.*;

public class PasswordGenerator {
    final static Random rand = new Random();

    public static void main(String[] args) {
        int num, len;

        try {
            if (args.length != 2)
                throw new IllegalArgumentException();

            len = Integer.parseInt(args[0]);
            if (len < 4 || len > 16)
                throw new IllegalArgumentException();

            num = Integer.parseInt(args[1]);
            if (num < 1 || num > 10)
                throw new IllegalArgumentException();

            for (String pw : generatePasswords(num, len))
                System.out.println(pw);

        } catch (IllegalArgumentException e) {
            String s = "Provide the length of the passwords (min 4, max 16) you "
                    + "want to generate,\nand how many (min 1, max 10)";
            System.out.println(s);
        }
    }

    private static List<String> generatePasswords(int num, int len) {
        final String s = "!\"#$%&'()*+,-./:;<=>?@[]^_{|}~";

        List<String> result = new ArrayList<>();

        for (int i = 0; i < num; i++) {
            StringBuilder sb = new StringBuilder();
            sb.append(s.charAt(rand.nextInt(s.length())));
            sb.append((char) (rand.nextInt(10) + '0'));
            sb.append((char) (rand.nextInt(26) + 'a'));
            sb.append((char) (rand.nextInt(26) + 'A'));

            for (int j = 4; j < len; j++) {
                int r = rand.nextInt(93) + '!';
                if (r == 92 || r == 96) {
                    j--;
                } else {
                    sb.append((char) r);
                }
            }
            result.add(shuffle(sb));
        }
        return result;
    }

    public static String shuffle(StringBuilder sb) {
        int len = sb.length();
        for (int i = len - 1; i > 0; i--) {
            int r = rand.nextInt(i);
            char tmp = sb.charAt(i);
            sb.setCharAt(i, sb.charAt(r));
            sb.setCharAt(r, tmp);
        }
        return sb.toString();
    }
}
