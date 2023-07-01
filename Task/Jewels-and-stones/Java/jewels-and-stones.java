import java.util.HashSet;
import java.util.Set;

public class App {
    private static int countJewels(String stones, String jewels) {
        Set<Character> bag = new HashSet<>();
        for (char c : jewels.toCharArray()) {
            bag.add(c);
        }

        int count = 0;
        for (char c : stones.toCharArray()) {
            if (bag.contains(c)) {
                count++;
            }
        }

        return count;
    }

    public static void main(String[] args) {
        System.out.println(countJewels("aAAbbbb", "aA"));
        System.out.println(countJewels("ZZ", "z"));
    }
}
