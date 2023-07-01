import static java.util.Arrays.asList;
import java.util.List;

public final class FlattenTestMain {

	public static void main(String[] args) {
		List<Object> treeList = a(a(1), 2, a(a(3, 4), 5), a(a(a())), a(a(a(6))), 7, 8, a());
		List<Object> flatList = FlattenUtil.flatten(treeList);
		System.out.println(treeList);
		System.out.println("flatten: " + flatList);
	}
	
	private static List<Object> a(Object... a) {
		return asList(a);
	}
}
