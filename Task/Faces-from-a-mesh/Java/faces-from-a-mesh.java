import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;

public final class FacesFromMesh {

	public static void main(String[] aArgs) {
		final List<Integer> perimeterFormatQ = Arrays.asList( 8, 1, 3 );
		final List<Integer> perimeterFormatR = Arrays.asList( 1, 3, 8 );
		final List<Integer> perimeterFormatU = Arrays.asList( 18, 8, 14, 10, 12, 17, 19 );
		final List<Integer> perimeterFormatV = Arrays.asList( 8, 14, 10, 12, 17, 19, 18 );
		
		final List<Edge> edgeFormatE = Arrays.asList( new Edge(1, 11), new Edge(7, 11), new Edge(1, 7) );	
		final List<Edge> edgeFormatF =
			Arrays.asList( new Edge(11, 23), new Edge(1, 17), new Edge(17, 23), new Edge(1, 11) );
		final List<Edge> edgeFormatG = Arrays.asList( new Edge(8, 14), new Edge(17, 19),
			new Edge(10, 12), new Edge(10, 14), new Edge(12, 17), new Edge(8, 18), new Edge(18, 19) );
		final List<Edge> edgeFormatH =
			Arrays.asList( new Edge(1, 3), new Edge(9, 11), new Edge(3, 11), new Edge(1, 11) );		
		
		System.out.println("PerimeterFormat equality checks:");
		boolean sameFace = isSameFace(perimeterFormatQ, perimeterFormatR);
		System.out.println(perimeterFormatQ + " == " + perimeterFormatR + ": " + sameFace);
		sameFace = isSameFace(perimeterFormatU, perimeterFormatV);
		System.out.println(perimeterFormatU + " == " + perimeterFormatV + ": " + sameFace);

		System.out.println(System.lineSeparator() + "EdgeFormat to PerimeterFormat conversions:");
		List<List<Edge>> edgeFormatFaces = List.of( edgeFormatE, edgeFormatF, edgeFormatG, edgeFormatH );
		for ( List<Edge> edgeFormatFace : edgeFormatFaces ) {
			List<Integer> perimeterFormatFace = toPerimeterFormatFace(edgeFormatFace);
		    if ( perimeterFormatFace.isEmpty() ) {
		    	System.out.println(edgeFormatFace + " has invalid edge format");
		    } else {
		        System.out.println(edgeFormatFace + " => " + perimeterFormatFace);
		    }
		}
	}
	
	private static boolean isSameFace(List<Integer> aOne, List<Integer> aTwo) {
		if ( aOne.size() != aTwo.size() || aOne.isEmpty() ||
			! new HashSet<Integer>(aOne).equals( new HashSet<Integer>(aTwo) )) {
			return false;
		}

		List<Integer> copyTwo = new ArrayList<Integer>(aTwo);
		for ( int i = 0; i < 2; i++ ) {
			int start = copyTwo.indexOf(aOne.get(0));
			List<Integer> test = new ArrayList<Integer>(copyTwo.subList(start, copyTwo.size()));
			test.addAll(copyTwo.subList(0, start));
			if ( aOne.equals(test) ) {
			    return true;
			}
			Collections.reverse(copyTwo);
		}	
		return false;
	}
	
	private static List<Integer> toPerimeterFormatFace(List<Edge> aEdgeFormatFace) {
		if ( aEdgeFormatFace.isEmpty() ) {
			return Collections.emptyList();
		}		
		
		List<Edge> edges = new ArrayList<Edge>(aEdgeFormatFace);
		List<Integer> result = new ArrayList<Integer>();
		Edge firstEdge = edges.remove(0);
		int nextVertex = firstEdge.first;
		result.add(nextVertex);
		
		while ( ! edges.isEmpty() ) {
			int index = -1;
			for ( Edge edge : edges ) {
				if ( edge.first == nextVertex || edge.second == nextVertex ) {
			        index = edges.indexOf(edge);
			        nextVertex = ( nextVertex == edge.first ) ? edge.second : edge.first;
			        break;
				}
			}			
			if ( index == -1 ) {
				return Collections.emptyList();
			}
			result.add(nextVertex);
			edges.remove(index);
		}
		
		if ( nextVertex != firstEdge.second ) {
		    return Collections.emptyList();
		}		
		return result;
	}
	
	private static class Edge {
		
		public Edge(int aFirst, int aSecond) {
			first = aFirst;
			second = aSecond;
		}
		
		@Override
		public String toString() {
			return "(" + first + ", " + second + ")";
		}
		
		private int first, second;
		
	}

}
