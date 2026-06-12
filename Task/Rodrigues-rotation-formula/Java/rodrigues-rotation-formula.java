public final class RogriguesRotationFormula {

	public static void main(String[] args) {
		Vector axis = new Vector(-1.0, 2.0, 1.0);
		Vector vector = new Vector(2.5, -1.5, 3.0);

		System.out.println(" Angle         Rotated vector");
		System.out.println("-----------------------------------");
		for ( double theta = 0.0; theta <= 2.0 * Math.PI; theta += Math.PI / 5.0 ) {
		    Vector result = axis.rodriguesRotation(vector, theta);
		    System.out.println(String.format("%.4f%s%s", theta, "    ", result));
		}
	}

}

final class Vector {
	
	public Vector(double aX, double aY, double aZ) {
		x = aX; y = aY; z = aZ;
	}
	
	public Vector unitVector() {
		return scalarMultiply(1.0 / Math.sqrt(dotProduct(this)));
	}
	
	public Vector add(Vector other) {	
		return new Vector(x + other.x, y + other.y, z + other.z);
	}
	
	public Vector scalarMultiply(double value) {
		return new Vector(x * value, y * value, z * value);
	}
	
	public double dotProduct(Vector other) {
		return x * other.x + y * other.y + z * other.z;
	}
	
	public Vector crossProduct(Vector other) {
		return new Vector(y * other.z - z * other.y,
						  z * other.x - x * other.z,
						  x * other.y - y * other.x);
	}
	
	public Vector rodriguesRotation(Vector vector, double angle) {
		Vector axis = unitVector();
		return vector.scalarMultiply(Math.cos(angle))
			.add(axis.crossProduct(vector).scalarMultiply(Math.sin(angle)))
			.add(axis.scalarMultiply(axis.dotProduct(vector) * ( 1.0 - Math.cos(angle) )));
	}
	
	public String toString() {
		return String.format("%s%.4f%s%.4f%s%.4f%s", "(", x, ", ", y, ", ", z, ")");
	}
	
	private final double x, y, z;
	
}
