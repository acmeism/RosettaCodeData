import java.util.Random;

public class QuickSelect {

	private static <E extends Comparable<? super E>> int partition(E[] arr, int left, int right, int pivot) {
		E pivotVal = arr[pivot];
		swap(arr, pivot, right);
		int storeIndex = left;
		for (int i = left; i < right; i++) {
			if (arr[i].compareTo(pivotVal) < 0) {
				swap(arr, i, storeIndex);
				storeIndex++;
			}
		}
		swap(arr, right, storeIndex);
		return storeIndex;
	}
	
	private static <E extends Comparable<? super E>> E select(E[] arr, int n) {
		int left = 0;
		int right = arr.length - 1;
		Random rand = new Random();
		while (right >= left) {
			int pivotIndex = partition(arr, left, right, rand.nextInt(right - left + 1) + left);
			if (pivotIndex == n) {
				return arr[pivotIndex];
			} else if (pivotIndex < n) {
				left = pivotIndex + 1;
			} else {
				right = pivotIndex - 1;
			}
		}
		return null;
	}
	
	private static void swap(Object[] arr, int i1, int i2) {
		if (i1 != i2) {
			Object temp = arr[i1];
			arr[i1] = arr[i2];
			arr[i2] = temp;
		}
	}
	
	public static void main(String[] args) {
		for (int i = 0; i < 10; i++) {
			Integer[] input = {9, 8, 7, 6, 5, 0, 1, 2, 3, 4};
			System.out.print(select(input, i));
			if (i < 9) System.out.print(", ");
		}
		System.out.println();
	}

}
