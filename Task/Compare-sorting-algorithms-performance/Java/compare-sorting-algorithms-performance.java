import java.util.Arrays;
import java.util.List;
import java.util.Random;
import java.util.function.Consumer;
import java.util.function.Function;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public final class ComparingSortingAlgorithmsPerformance {

	public static void main(String[] args) {
		final int repetitions = 10;
	    List<Integer> lengths = List.of( 1, 10, 100, 1_000, 10_000, 100_000 );
	    List<Consumer<int[]>> sorts = List.of( bubbleSort, insertionSort, quickSort, radixSort, shellSort );
	
	    // Allow the JVM to compile the sort functions before timings start
	    for ( Consumer<int[]> sort : sorts ) {
	    	sort.accept( new int[] { 1 } );
	    }

	    List<String> sortTitles = List.of( "Bubble", "Insert", "Quick ", "Radix ", "Shell " );
	    List<String> sequenceTitles = List.of( "All Ones", "Ascending", "Random" );
	
	    long[][][] totals = new long[sequenceTitles.size()][sorts.size()][lengths.size()];
	    for ( int k = 0; k < lengths.size(); k++ ) {
	    	final int n = lengths.get(k);
	        List<int[]> sequences = List.of( ones.apply(n), ascending.apply(n), random.apply(n) );
	        for ( int repetition = 0; repetition < repetitions; repetition++ ) {
	            for ( int i = 0; i < sequences.size(); i++ ) {
	                for ( int j = 0; j < sorts.size(); j++ ) {
	                    totals[i][j][k] += measureExecutionTime(sorts.get(j), sequences.get(i));
	                }
	            }
	        }
	    }
	
	    System.out.println("All timings in microseconds." + System.lineSeparator());
	    System.out.print("Sequence length");
	    for ( int length : lengths ) {
	    	System.out.print(String.format("%8d   ", length));
	    }
	    System.out.println(System.lineSeparator());
	
	    for ( int i = 0; i < sequenceTitles.size(); i++ ) {
	        System.out.println("  " + sequenceTitles.get(i) + ":");
	        for ( int j = 0; j < sorts.size(); j++ ) {
	            System.out.print("    " + sortTitles.get(j) + "     ");
	            for ( int k = 0; k < lengths.size(); k++ ) {
	                final long executionTime = totals[i][j][k] / repetitions;
	                System.out.print(String.format("%8d   ", executionTime));
	            }
	            System.out.println();
	        }
	        System.out.println(System.lineSeparator());
	    }
	}	
	
	private static Consumer<int[]> bubbleSort = array -> {
	    int n = array.length;
	    while ( n != 0 ) {
	        int n2 = 0;
	        for ( int i = 1; i < n; i++ ) {
	            if ( array[i - 1] > array[i] ) {
	                final int temp = array[i];
	                array[i] = array[i - 1];
	                array[i - 1] = temp;
	                n2 = i;
	            }
	        }
	        n = n2;
	    }
	};

	private static Consumer<int[]> insertionSort = array -> {
	    for ( int index = 1; index < array.length; index++ ) {
	        final int value = array[index];
	        int subIndex = index - 1;
	        while ( subIndex >= 0 && array[subIndex] > value ) {
	            array[subIndex + 1] = array[subIndex];
	            subIndex -= 1;
	        }
	        array[subIndex + 1] = value;
	    }
	};

	private static Consumer<int[]> quickSort = array -> {
		final class LocalClass {
			
			private static void quickSortRecursive(int[] array, int first, int last) {
				if ( last - first < 1 ) {
					return;
				}
		        final int pivot = array[first + ( last - first ) / 2];
		        int left = first;
		        int right = last;
		        while ( left <= right ) {
		            while ( array[left] < pivot ) {
		            	left += 1;
		            }
		            while ( array[right] > pivot ) {
		            	right -= 1;
		            }
		            if ( left <= right ) {
		                final int temp = array[left];
		                array[left] = array[right];
		                array[right] = temp;
		                left += 1;
		                right -= 1;
		            }
		        }
		        if ( first < right ) {
		        	quickSortRecursive(array, first, right);
		        }
		        if ( left < last ) {
		        	quickSortRecursive(array, left, last);
		        }		
			}
			
		}	
		
		LocalClass.quickSortRecursive(array, 0, array.length - 1);
	};
	
	private static Consumer<int[]> radixSort = array -> {	
	    final class LocalClass {
	    	
	    	private static void countingSort(int[] array, int exponent) {
	    		final int n = array.length;
	    	    int[] output = new int[n];
	    	    int[] count  = new int[10];
	    	    for ( int i = 0; i < n; i++ ) {
	    	        final int t = ( array[i] / exponent ) % 10;
	    	        count[t] += 1;
	    	    }
	    	    for ( int i = 1; i <= 9; i++ ) {
	    	    	count[i] += count[i - 1];
	    	    }
	    	    for ( int i = n - 1; i >= 0; i-- ) {
	    	        final int t = ( array[i] / exponent ) % 10;
	    	        output[count[t] - 1] = array[i];
	    	        count[t] -= 1;
	    	    }
	    	    for ( int i = 0; i < n; i++ ) {
	    	    	array[i] = output[i];
	    	    }
	    	}	    	
	    	
	    }
	
	    final int min = Arrays.stream(array).min().getAsInt();
		if ( min < 0 ) { // If there are any negative numbers, make all the numbers positive
			array = Arrays.stream(array).map( i -> i - min).toArray();
		}
		final int max = Arrays.stream(array).max().getAsInt();
		int exponent = 1;
	    while ( max / exponent > 0 ) {
	        LocalClass.countingSort(array, exponent);
	        exponent *= 10;
	    }
	    if ( min < 0 ) { // If there were any negative numbers, return the array to its original values
	    	array = Arrays.stream(array).map( i -> i + min).toArray();
	    }
	};	
	
	private static Consumer<int[]> shellSort = array -> {
	    for ( int gap : new int[] { 701, 301, 132, 57, 23, 10, 4, 1 } ) { // Marcin Ciura's gap sequence
	        for ( int i = gap; i < array.length; i++ ) {
	            final int temp = array[i];
	            int j = i;
	            while ( j >= gap && array[j - gap] > temp ) {
	                array[j] = array[j - gap];
	                j -= gap;
	            }
	            array[j] = temp;
	        }
	    }
	};
	
	private static Function<Integer, int[]> ones =
		n -> Stream.generate( () -> 1 ).limit(n).mapToInt(Integer::valueOf).toArray();
		
	private static Function<Integer, int[]> ascending = n -> IntStream.rangeClosed(1, n).toArray();
		
	private static Function<Integer, int[]> random = n -> new Random().ints(1, 10 * n).limit(n).toArray();
	
	private static long measureExecutionTime(Consumer<int[]> sort, int[] sequence) {
		final long startTime = System.nanoTime();
		sort.accept(sequence);
		return ( System.nanoTime() - startTime ) / 1_000; // microseconds
	}
	
}
