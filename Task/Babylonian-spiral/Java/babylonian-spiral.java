import java.awt.Point;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public final class BabylonianSpiral {

	public static void main(String[] aArgs) throws IOException {
		List<Point> points = babylonianSpiral(10_000);
		System.out.println("The first 40 points of the Babylonian spiral are:");
		for ( int i = 0, column = 0; i < 40; i++ ) {
			System.out.print(String.format("%9s%s",
				"(" + points.get(i).x + ", " + points.get(i).y + ")", ( ++column % 10 == 0 ) ? "\n" : " "));
		}
		System.out.println();
	
		String text = svgText(points, 800);		
		Files.write(Paths.get("C:/Users/psnow/Desktop/BabylonianSpiralJava.svg"), text.getBytes());
	}
	
	private static List<Point> babylonianSpiral(int aStepCount) {
		final double tau = 2 * Math.PI;
		List<Integer> squares = IntStream.rangeClosed(0, aStepCount).map( i -> i * i ).boxed().toList();
		List<Point> points = Stream.of( new Point(0, 0), new Point(0, 1) ).collect(Collectors.toList());
		int norm = 1;
		
		for ( int step = 0; step < aStepCount - 2; step++ ) {
		    Point previousPoint = points.get(points.size() - 1);
		    final double theta = Math.atan2(previousPoint.y, previousPoint.x);
		    Set<Point> candidates = new HashSet<Point>();
		    while ( candidates.isEmpty() ) {
		    	norm += 1;
			    for ( int i = 0; i < aStepCount; i++ ) {
			        int a = squares.get(i);
			        if ( a > norm / 2 ) {
			        	break;
			        }
			        for ( int j = (int) Math.sqrt(norm) + 1; j >= 0; j-- ) {
			        	int b = squares.get(j);	
			        	if ( a + b < norm ) {
			        		break;
			        	}
			        	if ( a + b == norm ) {
			        		candidates.addAll(
			        			List.of( new Point(i, j), new Point(-i, j), new Point(i, -j), new Point(-i, -j),
			        					 new Point(j, i), new Point(-j, i), new Point(j, -i), new Point(-j, -i) ));
			        	}
			        }
			    }
		    }
		
		    Comparator<Point> comparatorPoint = (one, two) -> Double.compare(
		    	( theta - Math.atan2(one.y, one.x) + tau ) % tau, ( theta - Math.atan2(two.y, two.x) + tau ) % tau);
		
		    Point minimum = candidates.stream().min(comparatorPoint).get();
		    points.add(minimum);
		}
		
		for ( int i = 0; i < points.size() - 1; i++ ) {
			points.set(i + 1, new Point(points.get(i).x + points.get(i + 1).x, points.get(i).y + points.get(i + 1).y));
		}
		return points;
	}

	private static String svgText(List<Point> aPoints, int aSize) {
    	StringBuilder text = new StringBuilder();
    	text.append("<svg xmlns='http://www.w3.org/2000/svg'");
        text.append(" width='" + aSize + "' height='" + aSize + "'>\n");
        text.append("<rect width='100%' height='100%' fill='cyan'/>\n");
        text.append("<path stroke-width='1' stroke='black' fill='cyan' d='");
        for ( int i = 0; i < aPoints.size(); i++ ) {
        	text.append(( i == 0 ? "M" : "L" ) +
        		( 150 + aPoints.get(i).x / 20 ) + ", " + ( 525 - aPoints.get(i).y / 20 ) + " ");
        }
        text.append("'/>\n</svg>\n");

        return text.toString();
    }
	
}
