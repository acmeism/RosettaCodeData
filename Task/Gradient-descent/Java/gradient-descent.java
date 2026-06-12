import java.util.function.Function;

public final class GradientDescent {

	public static void main(String[] args) {
		final double epsilon = 0.000_000_1;
		final double alpha = 0.1;
		final Point initialPoint = new Point(0.1, -1.0); // Initial estimate for the location of minimum point
		
		final Point minimum = gradientDescent(initialPoint, alpha, epsilon);
		System.out.println("Using the gradient descent method the minimum point occurs at:");
		System.out.println(String.format("%s%.6f%s%.6f%s%.6f",
			"x = ", minimum.x, ", ", minimum.y, " for which f(x, y) = ", f.apply(minimum)));
	}
	
	private static Point gradientDescent(Point minimum, double alpha, double epsilon) {		
		// Calculate initial values
		double minimumFunctionValue = f.apply(minimum);
		Point gradient = new Point(dfdx.apply(minimum), dfdy.apply(minimum));
		
		// Calculate the step size for the first iteration
		double deltaGradient = Math.hypot(gradient.x, gradient.y);
		double stepSize = alpha / deltaGradient;
		
		while ( deltaGradient > epsilon ) {
			// Calculate the next value for the minimum point
			minimum = new Point(minimum.x - stepSize * gradient.x, minimum.y - stepSize * gradient.y);	

	        // Calculate next gradient
			gradient = new Point(dfdx.apply(minimum), dfdy.apply(minimum));

			// Calculate the step size for the next iteration
			deltaGradient = Math.hypot(gradient.x, gradient.y);
			stepSize = alpha / deltaGradient;
			
			// Calculate the next function value
			double functionValue = f.apply(minimum);
		
			// Prepare for the next iteration
	        if ( functionValue > minimumFunctionValue ) {
	            alpha = alpha / 2;
	        } else {
	            minimumFunctionValue = functionValue;
	        }
		}
		
		return minimum;
	}
	
	private static Function<Point, Double> f = p ->
		( p.x - 1 ) * ( p.x - 1 ) * Math.exp(-p.y * p.y) + p.y * ( p.y + 2 ) * Math.exp(-2 * p.x * p.x);
		
	private static Function<Point, Double> dfdx = p ->
		2 * ( p.x - 1 ) * Math.exp(-p.y * p.y) - 4 * p.x * p.y * ( p.y + 2 ) * Math.exp(-2 * p.x * p.x);
		
	private static Function<Point, Double> dfdy = p ->
		-2 * p.y * ( p.x - 1 ) * ( p.x - 1 ) * Math.exp(-p.y * p.y) + 2 * ( p.y + 1 ) * Math.exp(-2 * p.x * p.x);
		
	private static record Point(double x, double y) {}

}
