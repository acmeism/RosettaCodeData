package org.rosettacode.java;

import java.util.Arrays;
import java.util.stream.IntStream;

public class HeapsAlgorithm {

	public static void main(String[] args) {
		Object[] array = IntStream.range(0, 4)
				.boxed()
				.toArray();
		HeapsAlgorithm algorithm = new HeapsAlgorithm();
		algorithm.recursive(array);
		System.out.println();
		algorithm.loop(array);
	}

	void recursive(Object[] array) {
		recursive(array, array.length, true);
	}

	void recursive(Object[] array, int n, boolean plus) {
		if (n == 1) {
			output(array, plus);
		} else {
			for (int i = 0; i < n; i++) {
				recursive(array, n - 1, i == 0);
				swap(array, n % 2 == 0 ? i : 0, n - 1);
			}
		}
	}

	void output(Object[] array, boolean plus) {
		System.out.println(Arrays.toString(array) + (plus ? " +1" : " -1"));
	}

	void swap(Object[] array, int a, int b) {
		Object o = array[a];
		array[a] = array[b];
		array[b] = o;
	}

	void loop(Object[] array) {
		loop(array, array.length);
	}

	void loop(Object[] array, int n) {
		int[] c = new int[n];
		output(array, true);
		boolean plus = false;
		for (int i = 0; i < n; ) {
			if (c[i] < i) {
				if (i % 2 == 0) {
					swap(array, 0, i);
				} else {
					swap(array, c[i], i);
				}
				output(array, plus);
				plus = !plus;
				c[i]++;
				i = 0;
			} else {
				c[i] = 0;
				i++;
			}
		}
	}
}
