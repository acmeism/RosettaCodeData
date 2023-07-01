import java.util.*;

public class SortComp1 {
    public static void main(String[] args) {
        List<String> items = Arrays.asList("violet", "red", "green", "indigo", "blue", "yellow", "orange");
        List<String> sortedItems = new ArrayList<>();
        Comparator<String> interactiveCompare = new Comparator<String>() {
                int count = 0;
                Scanner s = new Scanner(System.in);
                public int compare(String s1, String s2) {
                    System.out.printf("(%d) Is %s <, =, or > %s. Answer -1, 0, or 1: ", ++count, s1, s2);
                    return s.nextInt();
                }
            };
        for (String item : items) {
            System.out.printf("Inserting '%s' into %s\n", item, sortedItems);
            int spotToInsert = Collections.binarySearch(sortedItems, item, interactiveCompare);
            // when item does not equal an element in sortedItems,
            // it returns bitwise complement of insertion point
            if (spotToInsert < 0) spotToInsert = ~spotToInsert;
            sortedItems.add(spotToInsert, item);
        }
        System.out.println(sortedItems);
    }
}
