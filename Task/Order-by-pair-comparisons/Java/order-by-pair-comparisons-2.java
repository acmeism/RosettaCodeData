import java.util.*;

public class OrderByPair {
    public static void main(String[] args) {
        List<String> items = Arrays.asList("violet", "red", "green", "indigo", "blue", "yellow", "orange");
        Collections.sort(items, new Comparator<String>() {
                int count = 0;
                Scanner s = new Scanner(System.in);
                public int compare(String s1, String s2) {
                    System.out.printf("(%d) Is %s <, =, or > %s. Answer -1, 0, or 1: ", ++count, s1, s2);
                    return s.nextInt();
                }
            });
        System.out.println(items);
    }
}
