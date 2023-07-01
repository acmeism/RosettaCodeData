import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.AbstractList;

public class Disjoint {
    public static <T extends Comparable<? super T>> void sortDisjoint(
            final List<T> array, final int[] idxs) {
        Arrays.sort(idxs);
        Collections.sort(new AbstractList<T>() {
		public int size() { return idxs.length; }
		public T get(int i) { return array.get(idxs[i]); }
		public T set(int i, T x) { return array.set(idxs[i], x); }
	    });
    }

    public static void main(String[] args) {
        List<Integer> list = Arrays.asList(7, 6, 5, 4, 3, 2, 1, 0);
        int[] indices = {6, 1, 7};
        System.out.println(list);
        sortDisjoint(list, indices);
        System.out.println(list);
    }
}
