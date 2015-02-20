import java.nio.file.*;
import java.util.*;

public class Semordnilap {

    public static void main(String[] args) throws Exception {
        List<String> lst = Files.readAllLines(Paths.get("unixdict.txt"));
        Set<String> seen = new HashSet<>();
        int count = 0;
        for (String w : lst) {
            w = w.toLowerCase();
            String r = new StringBuilder(w).reverse().toString();
            if (seen.contains(r)) {
                if (count++ < 5)
                    System.out.printf("%-10s %-10s\n", w, r);
            } else seen.add(w);
        }
        System.out.println("\nSemordnilap pairs found: " + count);
    }
}
