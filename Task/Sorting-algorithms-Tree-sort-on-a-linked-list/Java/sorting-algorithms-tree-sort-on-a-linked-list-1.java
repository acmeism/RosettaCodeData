// TreeSortTest.java
import java.util.*;

public class TreeSortTest {
    public static void main(String[] args) {
        test1();
        System.out.println();
        test2();
    }

    // Sort a random list of integers
    private static void test1() {
        LinkedList<Integer> list = new LinkedList<>();
        Random r = new Random();
        for (int i = 0; i < 16; ++i)
            list.add(Integer.valueOf(r.nextInt(100)));
        System.out.println("before sort: " + list);
        list.treeSort();
        System.out.println(" after sort: " + list);
    }

    // Sort a list of strings
    private static void test2() {
        LinkedList<String> list = new LinkedList<>();
        String[] strings = { "one", "two", "three", "four", "five",
            "six", "seven", "eight", "nine", "ten"};
        for (String str : strings)
            list.add(str);
        System.out.println("before sort: " + list);
        list.treeSort();
        System.out.println(" after sort: " + list);
    }
}
