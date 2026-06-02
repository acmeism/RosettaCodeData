import module java.base;

public final class GenerateLowerCaseASCIIAlphabet {

	public static void main() {
		String ascii = IntStream.range('a', 'z').mapToObj( i -> String.valueOf((char) i) )
				                                .collect(Collectors.joining(""));
		IO.println(ascii);
	}

}
