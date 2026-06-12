public final class PrimeNumbersOfMeasurement {

	public static void main(String[] args) {
		int[] primeMeasures = new int[1_000];
		int primeMeasureIndex = 0;

		primeMeasures[0] = 1;
		primeMeasureIndex += 1;

		for ( int nextNumber = 2; nextNumber <= 5_000; nextNumber++ ) {
		    boolean foundPrimeMeasure = true;

		    for ( int startIndex = 0; startIndex <= primeMeasureIndex - 1; startIndex++ ) {
		        int sum = primeMeasures[startIndex];
		        for ( int endIndex = startIndex + 1; endIndex <= primeMeasureIndex - 1; endIndex++ ) {
		            sum += primeMeasures[endIndex];
		            if ( sum > nextNumber ) {
		            	break;
		            }
		            if ( sum == nextNumber ) {
		                foundPrimeMeasure = false;
		                break;
		            }
		        }
		        if ( ! foundPrimeMeasure ) {
		        	break;
		        }
		    }

		    if ( foundPrimeMeasure ) {
		        primeMeasures[primeMeasureIndex] = nextNumber;
		        primeMeasureIndex += 1;
		        if ( primeMeasureIndex >= 1_000 ) {
		        	break;
		        }
		    }
		}

		System.out.println("The first 100 prime measures:");
		for ( int i = 0; i < 100; i++ ) {
		    System.out.print(String.format("%3d%s", primeMeasures[i], ( i % 10 == 9 ? "\n" : " " )));
		}

		System.out.println(System.lineSeparator() + "One thousandth prime measure: " + primeMeasures[999]);
	}

}
