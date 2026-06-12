import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.IntStream;

public final class SunflowerFractal {

	public static void main(String[] args) throws IOException {
		final int size = 600;
		final int seedCount = 5 * size;
	    final double pi = 3.14159265359;
	    final double phi = 1.61803398875;
	
	    record Circle(double x, double y, double radius) {}
		
	    List<Circle> circles = IntStream.rangeClosed(1, seedCount).mapToObj( i -> {
	    	final double r = 2.0 * Math.pow(i, phi) / seedCount;
			final double theta = 2.0 * pi * phi * i;
			final double x = r * Math.sin(theta) + size / 2.0;
			final double y = r * Math.cos(theta) + size / 2.0;
			final double radius = Math.sqrt(i) / 13.0;
			return new Circle(x, y, radius);
	    } ).toList();
		
		StringBuilder builder = new StringBuilder();
		builder.append("<svg xmlns='http://www.w3.org/2000/svg\' width='" + size);
	    builder.append("' height='" + size + "' style='stroke:yellow'>\n");
	    builder.append("<rect width='100%' height='100%' fill='dark_gray'/>\n");
	    for ( Circle circle : circles ) {
	    	builder.append("<circle cx='" + circle.x + "' cy='" + circle.y + "' r='" + circle.radius + "'/>\n");
	    }
	    builder.append("</svg>\n");
	
	    Files.write(Paths.get("./SunflowerFractalJava.svg"), builder.toString().getBytes());
	}

}
