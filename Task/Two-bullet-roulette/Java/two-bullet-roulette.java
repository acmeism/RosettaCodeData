import java.util.BitSet;
import java.util.concurrent.ThreadLocalRandom;

public class TwoBulletRoulette {

	public static void main(String[] aArgs) {		
		Revolver handgun = new Revolver();
		final int simulationCount = 100_000;		
	
		for ( Situation situation : Situation.values() ) {
			double deaths = 0.0;
			for ( int i = 0; i < simulationCount; i++ ) {
				ResultState resultState = handgun.operateInMode(situation);
				if ( resultState == ResultState.DEAD) {
					deaths += 1.0;
				}
			}
			final double deathRate = ( deaths / simulationCount ) * 100;
			String percentage = String.format("%4.1f%%", deathRate);
			System.out.println("Situation " + situation + " produces " + percentage + " deaths");
		}
	}	
	
}

enum Situation { A, B, C, D }

enum ResultState { ALIVE, DEAD }

/**
 * Representation of a six cylinder revolving chamber pistol.
 */
class Revolver {
	
	public Revolver() {
		chambers = new BitSet(chamberCount);			
		random = ThreadLocalRandom.current();
	}	
	
	public ResultState operateInMode(Situation aSituation) {
		return switch ( aSituation ) {
			case A -> useSituationA();
			case B -> useSituationB();
			case C -> useSituationC();
			case D -> useSituationD();
		};
	}
	
	// PRIVATE //
	
	private void unload() {		
		chambers.clear();
	}
	
	private void load() {
		while ( chambers.get(loadingChamber) ) {
			rotateClockwise();
		}		
		chambers.set(loadingChamber);
		rotateClockwise();
	}	
	
	private void spin() {
		final int spins = random.nextInt(0, chamberCount);
		for ( int i = 0; i < spins; i++ ) {
			rotateClockwise();
		}
	}
	
	private boolean fire() {
		boolean fire = chambers.get(firingChamber);
		chambers.set(firingChamber, false);
		rotateClockwise();
		return fire;			
	}
	
	private void rotateClockwise() {		
		final boolean temp = chambers.get(chamberCount - 1);
		for ( int i = chamberCount - 2; i >= 0; i-- ) {
			chambers.set(i + 1, chambers.get(i));
		}
		chambers.set(firingChamber, temp);
	}
		
	private ResultState useSituationA() {
		unload();
		load();
		spin();
		load();
		spin();
		if ( fire() ) {
			return ResultState.DEAD;
		};
		spin();
		if ( fire() ) {
			return ResultState.DEAD;
		};
		
		return ResultState.ALIVE;
	}
	
	private ResultState useSituationB() {
		unload();
		load();
		spin();
		load();
		spin();
		if ( fire() ) {
			return ResultState.DEAD;
		};
		if ( fire() ) {
			return ResultState.DEAD;
		};
		
		return ResultState.ALIVE;
	}
	
	private ResultState useSituationC() {
		unload();
		load();
		load();
		spin();
		if ( fire() ) {
			return ResultState.DEAD;
		};
		spin();
		if ( fire() ) {
			return ResultState.DEAD;
		};
		
		return ResultState.ALIVE;
	}
	
	private ResultState useSituationD() {
		unload();
		load();
		load();
		spin();
		if ( fire() ) {
			return ResultState.DEAD;
		};
		if ( fire() ) {
			return ResultState.DEAD;
		};
		
		return ResultState.ALIVE;
	}	
	
	private BitSet chambers;
	private ThreadLocalRandom random;
	
	private final int firingChamber = 0;
	private final int loadingChamber = 1;
	private final int chamberCount = 6;
	
}
