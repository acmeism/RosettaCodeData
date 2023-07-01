import java.util.*;

class Test {

    public static void main(String[] args) {

        Object[] data = {1, 1, 2, 2, 3, 3, 3, "a", "a", "b", "b", "c", "d"};
        Set<Object> uniqueSet = new HashSet<Object>(Arrays.asList(data));
        for (Object o : uniqueSet)
            System.out.printf("%s ", o);
    }
}
