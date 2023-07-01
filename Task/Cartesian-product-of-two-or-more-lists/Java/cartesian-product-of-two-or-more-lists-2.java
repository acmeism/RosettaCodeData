import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class CartesianProduct<V> {

	public List<List<V>> product(List<List<V>> lists) {
		List<List<V>> product = new ArrayList<>();

		// We first create a list for each value of the first list
		product(product, new ArrayList<>(), lists);

		return product;
	}

	private void product(List<List<V>> result, List<V> existingTupleToComplete, List<List<V>> valuesToUse) {
		for (V value : valuesToUse.get(0)) {
			List<V> newExisting = new ArrayList<>(existingTupleToComplete);
			newExisting.add(value);

			// If only one column is left
			if (valuesToUse.size() == 1) {
				// We create a new list with the exiting tuple for each value with the value
				// added
				result.add(newExisting);
			} else {
				// If there are still several columns, we go into recursion for each value
				List<List<V>> newValues = new ArrayList<>();
				// We build the next level of values
				for (int i = 1; i < valuesToUse.size(); i++) {
					newValues.add(valuesToUse.get(i));
				}

				product(result, newExisting, newValues);
			}
		}
	}

	public static void main(String[] args) {
		List<Integer> list1 = new ArrayList<>(Arrays.asList(new Integer[] { 1776, 1789 }));
		List<Integer> list2 = new ArrayList<>(Arrays.asList(new Integer[] { 7, 12 }));
		List<Integer> list3 = new ArrayList<>(Arrays.asList(new Integer[] { 4, 14, 23 }));
		List<Integer> list4 = new ArrayList<>(Arrays.asList(new Integer[] { 0, 1 }));

		List<List<Integer>> input = new ArrayList<>();
		input.add(list1);
		input.add(list2);
		input.add(list3);
		input.add(list4);

		CartesianProduct<Integer> cartesianProduct = new CartesianProduct<>();
		List<List<Integer>> product = cartesianProduct.product(input);
		System.out.println(product);
	}
}
