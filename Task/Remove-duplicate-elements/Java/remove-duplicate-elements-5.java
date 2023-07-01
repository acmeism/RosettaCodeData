import java.util.*;

class Test {

    public static void main(String[] args) {

        Object[] data = {1, 1, 2, 2, 3, 3, 3, "a", "a", "b", "b", "c", "d"};
        Arrays.stream(data).distinct().forEach((o) -> System.out.printf("%s ", o));
    }
}
