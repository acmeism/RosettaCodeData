import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public final class OrderedPartitions {

	public static void main(String[] aArgs) {
		List<Integer> sizes = ( aArgs == null || aArgs.length == 0 ) ?
			List.of( 2, 0, 2 ) : Arrays.stream(aArgs).map( s -> Integer.valueOf(s) ).toList();
		
		System.out.println("Partitions for " + sizes + ":");
		final int total = sizes.stream().reduce(0, Integer::sum);
		List<Integer> permutation = IntStream.rangeClosed(1, total).boxed().collect(Collectors.toList());
	
		while ( hasNextPermutation(permutation) ) {
	        List<List<Integer>> partition = new ArrayList<List<Integer>>();
	        int sum = 0;
	        boolean isValid = true;
	        for ( int size : sizes ) {
            	List<Integer> subList = permutation.subList(sum, sum + size);
                if ( ! isIncreasing(subList) ) {
                    isValid = false;
                    break;
                }
                partition.add(subList);
	            sum += size;
	        }
	
	        if ( isValid ) {
	        	System.out.println(" ".repeat(4) + partition);
	        }	
	    }
	}
	
	private static boolean hasNextPermutation(List<Integer> aPerm) {
	    final int lastIndex = aPerm.size() - 1;
	    int i = lastIndex;
	    while ( i > 0 && aPerm.get(i - 1) >= aPerm.get(i) ) {
	        i--;
	    }
	
	    if ( i <= 0 ) {
	        return false;
	    }
	
	    int j = lastIndex;
	    while ( aPerm.get(j) <= aPerm.get(i - 1) ) {
	        j--;
	    }	
	    swap(aPerm, i - 1, j);
	
	    j = lastIndex;
	    while ( i < j ) {
	    	swap(aPerm, i++, j--);
	    }
	
	    return true;
	}
	
	private static boolean isIncreasing(List<Integer> aList) {
	    return aList.stream().sorted().toList().equals(aList);
	}
	
	private static void swap(List<Integer> aList, int aOne, int aTwo) {
		final int temp = aList.get(aOne);
	    aList.set(aOne, aList.get(aTwo));
	    aList.set(aTwo, temp);
	}

}
