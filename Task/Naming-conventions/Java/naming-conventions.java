import java.util.ArrayList;
import java.util.List;

public class NamingConventions {

	public static void main(String[] arguments) {		
	    SolarSystem solarSystem = new SolarSystem();
	    solarSystem.showSunDiameter();
	    System.out.println("The planetary system comprises of:");
	    solarSystem.listPlanets();
	}

}

enum Planet { MERCURY, VENUS, EARTH, MARS, JUPITER, SATURN, URANUS, NEPTUNE, PLUTO }

class SolarSystem {
	
	public SolarSystem() {
		for ( Planet planet : Planet.values() ) {
			planets.add(planet);
		}
	}
	
	 public void showSunDiameter() {
		 System.out.println("The diameter of the sun is approximately " + SOLAR_DIAMETER + " km");
	 }
	
	public void listPlanets() {
		System.out.println(planets);
	}
	
    private List<Planet> planets = new ArrayList<Planet>();

    private static final int SOLAR_DIAMETER = 1_390_000;

}
