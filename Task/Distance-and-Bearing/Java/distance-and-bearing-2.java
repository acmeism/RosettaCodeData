import distanceAndBearing.DistanceAndBearing;
public class MyClass {

	public static void main(String[] args) {
		DistanceAndBearing dandb = new DistanceAndBearing();
		dandb.readFile("airports.txt");
		dandb.findClosestAirports(51.514669,2.198581);
	}
}
