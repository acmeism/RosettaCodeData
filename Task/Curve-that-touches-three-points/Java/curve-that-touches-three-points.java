import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

public final class CurveThatTouchesThreePoints {

	public static void main(String[] args) throws IOException {
		final double x1 =  10.0, y1 =  10.0; // point P1
		final double x2 = 100.0, y2 = 200.0; // point P2
		final double x3 = 200.0, y3 =  10.0; // point P3		
		
		final double x4 = ( x1 + x2 ) / 2.0; // x-coordinate of midpoint of line L1 between P1 and P2
		final double y4 = ( y1 + y2 ) / 2.0; // y-coordinate of midpoint of line L1 between P1 and P2
		final double slope4 = ( y2 - y1 ) / ( x2 - x1 ); // gradient of line LI
		final double gradient4 = -1.0 / slope4;          // gradient of line O1 orthogonal to L1
		final double intercept4 = y4 - gradient4 * x4;   // intercept of line O1 on y-axis		
		// Line O1 has equation: Y = gradient4 * X + intercept4
		
		final double x5 = ( x2 + x3 ) / 2.0; // x-coordinate of midpoint of line L2 between P2 and P3
		final double y5 = ( y2 + y3 ) / 2.0; // y-coordinate of midpoint of line L2 between P2 and P3
		final double slope5 = ( y3 - y2 ) / ( x3 - x2 ); // gradient of line L2
		final double gradient5 = -1.0 / slope5;          // gradient of line O2 orthogonal to L2
		final double intercept5 = y5 - gradient5 * x5;   // intercept of line O2 on y-axis
		// Line O2 has equation: Y = gradient5 * X + intercept5
		
		// Solving the equations for lines O1 and O2
		final double centreX = ( intercept5 - intercept4 ) / ( gradient4 - gradient5 );
		final double centreY = gradient4 * centreX + intercept4;
		
		final double radius = Math.sqrt(Math.pow(x1 - centreX, 2) + Math.pow(y1 - centreY, 2));
		
		final int size = 300;
		final int marginX = 50;
		final int marginY = 70;
		
    	StringBuilder svgText = new StringBuilder();
    	svgText.append("<svg xmlns='http://www.w3.org/2000/svg'");
        svgText.append(" width='" + size + "' height='" + size + "'>\n");
        svgText.append("<rect width='100%' height='100%' fill='cyan'/>\n");
        svgText.append("<circle r='" + radius + "' cx='" + ( centreX + marginX )
        	+ "' cy='" + ( size - centreY - marginY ) + "' stroke='red' stroke-width='3' fill='cyan'/>");
        svgText.append("<line x1='0' y1='" + ( size - marginY ) + "' x2='"
        	+ size + "' y2='" + ( size - marginY ) + "' stroke='black' stroke-width='1'/>");
        svgText.append("<line x1='" + marginX + "' y1='0' x2='" + marginX + "' y2='"
        	+ size + "' stroke='black' stroke-width='1'/>");
        svgText.append("'\n</svg>\n");
        String svg = svgText.toString();
	
        Files.write(Paths.get("./CurveThreePointsJava.svg"), svg.getBytes());
	}

}
