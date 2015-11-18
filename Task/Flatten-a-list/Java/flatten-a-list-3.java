import java.util.List;
import java.util.stream.Stream;
import java.util.stream.Collectors;

public final class FlattenUtil {

	public static Stream<Object> flattenToStream(List<?> list) {
		return list.stream().flatMap(item ->
			item instanceof List<?> ?
			flattenToStream((List<?>)item) :
			Stream.of(item));
	}

	public static List<Object> flatten(List<?> list) {
		return flattenToStream(list).collect(Collectors.toList());
	}
}
