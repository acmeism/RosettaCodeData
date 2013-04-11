import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class Disjoint {
    public static <T extends Comparable<? super T>> void sortDisjoint(
            List<T> array, int[] idxs) {
        Arrays.sort(idxs);
        List<T> disjoint = new ArrayList<T>();
        for (int idx : idxs) {
            disjoint.add(array.get(idx));
        }
        Collections.sort(disjoint);
        int i = 0;
        for (int idx : idxs) {
            array.set(idx, disjoint.get(i++));
        }
    }

    public static void main(String[] args) {
        List<Integer> list = Arrays.asList(7, 6, 5, 4, 3, 2, 1, 0);
        int[] indices = {6, 1, 7};
        System.out.println(list);
        sortDisjoint(list, indices);
        System.out.println(list);
    }
}
