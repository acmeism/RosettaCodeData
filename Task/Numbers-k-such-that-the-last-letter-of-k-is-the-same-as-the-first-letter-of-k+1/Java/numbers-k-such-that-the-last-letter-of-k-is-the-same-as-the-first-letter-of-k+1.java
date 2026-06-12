import java.util.Arrays;

public final class NumbersKSuchThatTheLastLetterOfKIsTheSameAsTheFirstLetterOfKPlusOne {

	public static void main(String[] args) {
		System.out.println("The first 50 numbers:");
	    A363659Generator generator = new A363659Generator();
	    int[] digitCount = new int[10];
	    int index = 1;
	    int number = 0;	
	    while ( index <= 50 ) {
	        number = generator.next();
	        digitCount[number % 10] += 1;
	        System.out.print(String.format("%3d%s", number, ( index % 10 == 0 ) ? "\n" : " " ));
	        index += 1;
	    }
	    System.out.println();
	
	    for ( int limit = 1_000; limit <= 1_000_000; limit *= 10 ) {
	        while ( index <= limit ) {
	            number = generator.next();
	            digitCount[number % 10] += 1;
	            index += 1;
	        }	
	        System.out.println("The " + limit + "th number is " + number + ".");
	        System.out.println("Breakdown by last digit of first " + limit + " numbers:");
	        drawHistogram(digitCount);
	    }
	}
	
	private static void drawHistogram(int[] digitCount) {
	    final int MAX_VALUE = Arrays.stream(digitCount).boxed().max(Integer::compare).get();
	    final int WIDTH = 60;
	    for ( int i = 0; i < digitCount.length; i++ ) {
	        System.out.print(i + ": ");
	        final int rowLength = ( MAX_VALUE != 0 ) ? ( digitCount[i] * WIDTH ) / MAX_VALUE : 0;
	        for  ( int index = 0; index < WIDTH; index++ ) {
	        	String toPrint = ( index < rowLength ) ? "■" : " ";
	        	System.out.print(toPrint);
	        }
	        System.out.println(" " + digitCount[i]);
	    }
	    System.out.println();
	}
	
}

final class A363659Generator {

    public A363659Generator() {
        for ( int i = 0; i < 1_000; i++ ) {
            String name = NumberToWordsConverter.convert(i);
            firstChar[i] = name.toLowerCase().charAt(0);
            lastChar[i] = name.charAt(name.length() - 1);
        }
    }

    public int next() {    	
        while ( firstChar(number + 1) != lastChar(number) ) {
            number += 1;
        }
        return number++;
    }

    private char firstChar(int n) {
        int i = 0;
        while ( n > 0 ) {
            i = n % 1_000;
            n /= 1_000;
        }
        return firstChar[i];
    }

    private char lastChar(int n) {
        final int i = n % 1_000;
        if ( i > 0 ) {
            return lastChar[i];
        }
        if ( n == 0 ) {
            return lastChar[0];
        }
        if ( n % 1_000_000 == 0 ) {
            return 'n';
        }
        return 'd';
    }

    private int number = 0;
    private char[] firstChar = new char[1_000];
    private char[] lastChar = new char[1_000];

}

final class NumberToWordsConverter { // Valid for positive integers ≤ 999_999_999	

	public static String convert(int n) {
		if ( n < 20 ) {
			return units[n];
		}
		if ( n < 100 ) {
			return tens[n / 10] + ( ( n % 10 > 0 ) ? " " + convert(n % 10) : "" );
		}
		if ( n < 1_000 ) {
			return units[n / 100] + " Hundred" + ( ( n % 100 > 0 ) ? " and " + convert(n % 100) : "" );
		}
		if ( n < 1_000_000 ) {
			return convert(n / 1_000) + " Thousand" + ( ( n % 1_000 > 0 ) ? " " + convert(n % 1_000) : "" );
		}
		return convert(n / 1_000_000) + " Million"
		    + ( ( n % 1_000_000 > 0 ) ? " " + convert(n % 1_000_000) : "" );		
	}
	
	private static final String[] units = { "Zero", "One", "Two", "Three", "Four", "Five", "Six",
		"Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve", "Thirteen",
		"Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen" };
	
	private static final String[] tens =
		{ "","", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety" };
	
}
