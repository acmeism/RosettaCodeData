/* TrySort.java */

import java.util.Collections;
import java.util.Random;

public class TrySort {
    static boolean useC;
    static {
	try {
	    System.loadLibrary("TrySort");
	    useC = true;
	} catch(UnsatisfiedLinkError e) {
	    useC = false;
	}
    }

    static native void sortInC(int[] ary);

    static class IntList extends java.util.AbstractList<Integer> {
	int[] ary;
	IntList(int[] ary) { this.ary = ary; }
	public Integer get(int i) { return ary[i]; }
	public Integer set(int i, Integer j) {
	    Integer o = ary[i]; ary[i] = j; return o;
	}
	public int size() { return ary.length; }
    }

    static class ReverseAbsCmp
	implements java.util.Comparator<Integer>
    {
	public int compare(Integer pa, Integer pb) {
	    /* Order from highest to lowest absolute value. */
	    int a = pa > 0 ? -pa : pa;
	    int b = pb > 0 ? -pb : pb;
	    return a < b ? -1 : a > b ? 1 : 0;
	}
    }

    static void sortInJava(int[] ary) {
	Collections.sort(new IntList(ary), new ReverseAbsCmp());
    }

    public static void main(String[] args) {
	/* Create an array of random integers. */
	int[] ary = new int[1000000];
	Random rng = new Random();
	for (int i = 0; i < ary.length; i++)
	    ary[i] = rng.nextInt();

	/* Do the reverse sort. */
	if (useC) {
	    System.out.print("Sorting in C...  ");
	    sortInC(ary);
	} else {
	    System.out.print
		("Missing library for C!  Sorting in Java...  ");
	    sortInJava(ary);
	}

	for (int i = 0; i < ary.length - 1; i++) {
	    int a = ary[i];
	    int b = ary[i + 1];
	    if ((a > 0 ? -a : a) > (b > 0 ? -b : b)) {
		System.out.println("*BUG IN SORT*");
		System.exit(1);
	    }
	}
	System.out.println("ok");
    }
}
