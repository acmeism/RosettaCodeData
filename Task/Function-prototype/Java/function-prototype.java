public final class FunctionPrototype {
	
	public static void main(String[] aArgs) {
		Rectangle rectangle = new Rectangle(10.0, 20.0);
		System.out.println("Area = " + rectangle.area());
		
		Calculator calculator = new Calculator();
		System.out.println("Sum = " + calculator.sum(2, 2));
		calculator.version();
	}	

	private static class Rectangle implements Shape {
		
		public Rectangle(double aWidth, double aLength) {
			width = aWidth; length = aLength;
		}
		
		@Override
	    public double area() {
	        return length * width;
	    }		
		
		private final double width, length;
	
	}	
	
	private static class Calculator extends Arithmetic {
		
		public Calculator() {
			// Statements to create the graphical
			// representation of the calculator
		}
		
		@Override
		public int sum(int aOne, int aTwo) {
			return aOne + aTwo;
		}
		
		@Override
		public void version() {
			System.out.println("0.0.1");
		}
		
	}	

}

interface Shape {
    public double area();
}	

abstract class Arithmetic {
	public abstract int sum(int aOne, int aTwo);
	public abstract void version();		
}
