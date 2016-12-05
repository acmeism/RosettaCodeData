import java.util.Arrays;
import java.util.stream.IntStream;

public class VectorsOp {
	// Vector dot product using Java SE 8 stream abilities
	// the method first create an array of size values,
	// and map the product of each vectors components in a new array (method map())
	// and transform the array to a scalr by summing all elements (method reduce)
	// the method parallel  is there for optimization
	private static int dotProduct(int[] v1, int[] v2,int length) {
	
	int result = IntStream.range(0, length)
	                           .parallel()
	                            .map( id -> v1[id] * v2[id])
	                            .reduce(0, Integer::sum);

	    return result;
	}

	// Vector Cross product using Java SE 8 stream abilities
	// here we map in a new array where each element is equal to the cross product
	// With Stream is is easier to handle N dimensions vectors
	private static int[] crossProduct(int[] v1, int[] v2,int length) {

		int  result[] = new int[length] ;
		//result[0] = v1[1] * v2[2] - v1[2]*v2[1] ;
		//result[1] = v1[2] * v2[0] - v1[0]*v2[2] ;
		// result[2] = v1[0] * v2[1] - v1[1]*v2[0] ;
		
		result = IntStream.range(0, length)
			.parallel()
	 		.map( i ->   v1[(i+1)%length] * v2[(i+2)%length] -  v1[(i+2)%length]*v2[(i+1)%length])
	 		.toArray();

		 return result;
	}

	public static void main (String[] args)
	{
	   	int[] vect1 = {3, 4, 5};
	   	int[] vect2 = {4, 3, 5};
	    int[] vect3 = {-5, -12, -13};

	    System.out.println("dot product =:" + dotProduct(vect1,vect2,3));

	    int[] prodvect = new int[3];
	    prodvect = crossProduct(vect1,vect2,3);
	    System.out.println("cross product =:[" + prodvect[0] + ","
	    	                                   + prodvect[1] + ","
	    	                                   + prodvect[2] + "]");

	    prodvect = crossProduct(vect2,vect3,3);
	    System.out.println("scalar product =:" + dotProduct(vect1,prodvect,3));

	    prodvect = crossProduct(vect1,prodvect,3);

	    System.out.println("triple product =:[" + prodvect[0] + ","
	    	                                   + prodvect[1] + ","
	    	                                   + prodvect[2] + "]");

	   }
}
