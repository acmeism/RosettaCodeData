import java.util.List;
import java.util.Collections;
import java.util.Arrays;

public static <T extends Comparable<? super T>> T max(List<T> values) {
    return Collections.max(values);
}

public static <T extends Comparable<? super T>> T max(T[] values) {
    return Collections.max(Arrays.asList(values));
}
