import java.util.List;

public final class PeriodicTable {

	public static void main(String[] aArgs) {
		for ( int atomicNumber : List.of( 1, 2, 29, 42, 57, 58, 59, 71, 72, 89, 90, 103, 113 ) ) {
		    Position position = periodicTable(atomicNumber);
		    System.out.println(String.format("%s%-3d%s%d%s%d",
		    	"Atomic number ", atomicNumber, " -> ", position.period, ", ", position.group));
		}
	}
	
	private static Position periodicTable(int aAtomicNumber) {		
	    if ( aAtomicNumber < 1 || aAtomicNumber > 118 ) {
	    	throw new IllegalArgumentException("Atomic number is out of range:" + aAtomicNumber);
	    }
	
	    if ( aAtomicNumber == 1 ) { // Hydrogen
	    	return new Position(1, 1);
	    }
	    if ( aAtomicNumber == 2 ) { // Helium
	    	return new Position(1, 18);
	    }
	    if ( aAtomicNumber >= 57 && aAtomicNumber <= 71 ) { // Lanthanides
	    	return new Position(8, aAtomicNumber - 53);
	    }
	    if ( aAtomicNumber >= 89 && aAtomicNumber <= 103 ) { // Actinides
	    	return new Position(9, aAtomicNumber - 85);
	    }
	
	    int period = 0;
	    int periodFirst = 0;
	    int periodLast = 0;
	    for ( int i = 0; i < GROUPS.size() && period == 0; i++ ) {
	        Group group = GROUPS.get(i);
	        if ( aAtomicNumber >= group.first && aAtomicNumber <= group.last ) {
	            period = i + 2;
	            periodFirst = group.first;
	            periodLast = group.last;
	        }
	    }
	
	    if ( aAtomicNumber < periodFirst + 2 || period == 4 || period == 5 ) {
	    	return new Position(period, aAtomicNumber - periodFirst + 1);
	    }
	    return new Position(period, aAtomicNumber - periodLast + 18);
	}
	
	private static record Group(int first, int last) {}
	private static record Position(int period, int group) {}
	
	private static final List<Group> GROUPS = List.of( new Group(3, 10), new Group(11, 18),
		new Group(19, 36), new Group(37, 54), new Group(55, 86), new Group(87, 118) );

}
