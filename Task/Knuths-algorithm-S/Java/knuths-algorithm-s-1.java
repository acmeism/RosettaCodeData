import java.util.*;

class SOfN<T> {
    private static final Random rand = new Random();

    private List<T> sample;
    private int i = 0;
    private int n;
    public SOfN(int _n) {
	n = _n;
	sample = new ArrayList<T>(n);
    }
    public List<T> process(T item) {
	i++;
	if (i <= n) {
            sample.add(item);
	} else if (rand.nextInt(i) < n) {
	    sample.set(rand.nextInt(n), item);
	}
	return sample;
    }
}

public class AlgorithmS {
    public static void main(String[] args) {
	int[] bin = new int[10];
	for (int trial = 0; trial < 100000; trial++) {
	    SOfN<Integer> s_of_n = new SOfN<Integer>(3);
	    List<Integer> sample = null;
	    for (int i = 0; i < 10; i++)
		sample = s_of_n.process(i);
	    for (int s : sample)
		bin[s]++;
	}
	System.out.println(Arrays.toString(bin));
    }
}
