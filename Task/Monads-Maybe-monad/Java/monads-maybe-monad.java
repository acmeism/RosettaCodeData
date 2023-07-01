import java.util.Optional;

public final class MonadMaybe {

	public static void main(String[] aArgs) {
	    System.out.println(doubler(5).flatMap(MonadMaybe::stringify).get());
	
	    System.out.println(doubler(2).flatMap(MonadMaybe::stringifyNullable).get());
	
	    Optional<String> option = doubler(0).flatMap(MonadMaybe::stringifyNullable);
	
	    String result = option.isPresent() ? option.get() : "Result is Null";
	
	    System.out.println(result);
	}
	
	private static Optional<Integer> doubler(int aN) {
		return Optional.of(2 * aN);
	}

	private static Optional<String> stringify(int aN) {
		return Optional.of("A".repeat(aN));
	}

	private static Optional<String> stringifyNullable(int aN) {
		return ( aN > 0 ) ? Optional.ofNullable("A".repeat(aN)) : Optional.ofNullable(null);
	}

}
