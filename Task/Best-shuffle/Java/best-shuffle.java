import java.util.Random;

public class BestShuffle {
    private final static Random rand = new Random();

    public static void main(String[] args) {
        String[] words = {"abracadabra", "seesaw", "grrrrrr", "pop", "up", "a"};
        for (String w : words)
            System.out.println(bestShuffle(w));
    }

    public static String bestShuffle(final String s1) {
        char[] s2 = s1.toCharArray();
        shuffle(s2);
        for (int i = 0; i < s2.length; i++) {
            if (s2[i] != s1.charAt(i))
                continue;
            for (int j = 0; j < s2.length; j++) {
                if (s2[i] != s2[j] && s2[i] != s1.charAt(j) && s2[j] != s1.charAt(i)) {
                    char tmp = s2[i];
                    s2[i] = s2[j];
                    s2[j] = tmp;
                    break;
                }
            }
        }
        return s1 + " " + new String(s2) + " (" + count(s1, s2) + ")";
    }

    public static void shuffle(char[] text) {
        for (int i = text.length - 1; i > 0; i--) {
            int r = rand.nextInt(i + 1);
            char tmp = text[i];
            text[i] = text[r];
            text[r] = tmp;
        }
    }

    private static int count(final String s1, final char[] s2) {
        int count = 0;
        for (int i = 0; i < s2.length; i++)
            if (s1.charAt(i) == s2[i])
                count++;
        return count;
    }
}
