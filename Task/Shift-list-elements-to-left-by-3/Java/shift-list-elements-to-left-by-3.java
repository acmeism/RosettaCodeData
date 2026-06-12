import java.util.List;
import java.util.Arrays;
import java.util.Collections;

public class RotateLeft {
    public static void main(String[] args) {
        List<Integer> list = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9);
        System.out.println("original: " + list);
        Collections.rotate(list, -3);
        System.out.println("rotated: " + list);
    }
}
