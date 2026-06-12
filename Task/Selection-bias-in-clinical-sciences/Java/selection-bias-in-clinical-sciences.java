import java.util.List;
import java.util.random.RandomGenerator;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public final class SelectionBiasInClinicalScience {

	public static void main(String[] args) {
		runStudy(10_000, 180, 30);
	}
	
	// Run the study using the population of size 'subjectsCount' for 'duration' days
	private static void runStudy(int subjectCount, int duration, int reportingInterval) {
		List<Subject> subjects = Stream.generate( () -> new Subject() )
				                       .limit(subjectCount).collect(Collectors.toList());	
	    long untr = 0;
	    long untrCov = 0;
	    long irreg = 0;
	    long irregCov = 0;
	    long reg = 0;
	    long regCov = 0;
	    System.out.println("Total number of subjects: " + subjectCount);
	
	    for ( int day = 0; day < duration; day++ ) {
	        for ( Subject subject : subjects ) {
	        	subject.update(0.001, 0.005, 0.25, List.of( 3, 6, 9 ));
	        }
	
	        if ( ( day + 1 ) % reportingInterval == 0 ) {
	            System.out.println("\nDay %d:".formatted(day + 1));
	            untr = subjects.stream().filter( s -> s.category == Category.UNTREATED ).count();
	            untrCov = subjects.stream().filter( s -> s.category == Category.UNTREATED && s.hadCovid ).count();
	            System.out.println("Untreated: %d, with infection %d".formatted(untr, untrCov));
	            irreg = subjects.stream().filter( s -> s.category == Category.IRREGULAR ).count();
	            irregCov = subjects.stream().filter( s -> s.category == Category.IRREGULAR && s.hadCovid ).count();
	            System.out.println("Irregular: %d, with infection %d".formatted(irreg, irregCov));
	            reg = subjects.stream().filter( s -> s.category == Category.REGULAR ).count();
	            regCov = subjects.stream().filter( s -> s.category == Category.REGULAR && s.hadCovid ).count();
	            System.out.println("Regular Use: %d, with infection %d".formatted(reg, regCov));
	        }
	
	        if ( day == ( duration / 2 ) - 1 ) {
	            System.out.println("\nAt the midpoint of the study, infection case percentages are:");
	            System.out.println("  Untreated : %.4f".formatted(( 100.0 * untrCov ) / untr));
	            System.out.println("  Irregulars: %.4f".formatted(( 100.0 * irregCov ) / irreg));
	            System.out.println("  Regulars  : %.4f".formatted(( 100.0 * regCov ) / reg));
	        }	
	    }
	
	    System.out.println("\nAt the end of the study, infection case percentages are:");
	    System.out.println("  Untreated : %.4f of group size %d".formatted(( 100.0 * untrCov / untr ), untr));
	    System.out.println("  Irregulars: %.4f of group size %d".formatted(( 100.0 * irregCov / irreg ), irreg));
	    System.out.println("  Regulars  : %.4f of group size %d".formatted(( 100.0 * regCov / reg ), reg));
	
	    List<Integer> untreated = subjects.stream()
	    	.filter( s -> s.category == Category.UNTREATED ).map( s -> s.hadCovid ? 1 : 0 ).toList();
	    List<Integer> irregular = subjects.stream()
	    	.filter( s -> s.category == Category.IRREGULAR ).map( s -> s.hadCovid ? 1 : 0 ).toList();
	    List<Integer> regular = subjects.stream().
	    	filter( s -> s.category == Category.REGULAR ).map( s -> s.hadCovid ? 1 : 0 ).toList();
	
	    System.out.println("\nFinal statistics: H = " + kruskalWallis(untreated, irregular, regular));	
	}	
	
	private static float kruskalWallis(List<Integer> a, List<Integer> b, List<Integer> c) {
		List<Integer> total = Stream.of(a.stream(), b.stream(), c.stream()).flatMap( i -> i ).sorted().toList();	
		final int n = total.size();
		 // Find the rank of first occurrence of 1
	    final int index = total.indexOf(1) + 1;	
	    // Calculate the average ranks for 0 and 1
	    final double arf = (double) index / 2.0;	
	    final double art = (double) ( index + n ) / 2.0;
	    // Calculate the sum of ranks for each list
	    final double sra = a.stream().map( i -> i == 1 ? art : arf ).mapToDouble( f -> f ).sum();
	    final double srb = b.stream().map( i -> i == 1 ? art : arf ).mapToDouble( f -> f ).sum();
	    final double src = c.stream().map( i -> i == 1 ? art : arf ).mapToDouble( f -> f ).sum();
	    final double sum = sra * sra / a.size() + srb * srb / b.size() + src * src / c.size();
	    final double H = ( 12.0 * sum ) / n / ( n + 1 ) - 3 * n - 3;
	    return (float) H;
	}
	
	// A subject of the clinical study
	private static final class Subject {
		
		public Subject() {
	        cumulativeDose = 0;
	        category = Category.UNTREATED;
	        hadCovid = false;
	    }
		
		// Daily update on the subject to check for infection and randomly dose
	    public void update(double pCovid, double pStartingTreatment, double pRedose, List<Integer> doseRange) {
	        if ( ! hadCovid ) {
	            if ( RANDOM.nextDouble() < pCovid ) {
	                hadCovid = true;
	            } else if ( ( cumulativeDose == 0 && RANDOM.nextDouble() < pStartingTreatment ) ||
	                       ( cumulativeDose > 0 && RANDOM.nextDouble() < pRedose ) ) {
	                cumulativeDose += doseRange.get(RANDOM.nextInt(doseRange.size()));
	                categorize();
	            }
	        }
	    }
	
	    // Set treatment category based on cumulative treatment taken
	    private void categorize() {
	        category = ( cumulativeDose == 0 ) ? Category.UNTREATED :
	        	( cumulativeDose >= DOSE_FOR_REGULAR ) ? Category.REGULAR : Category.IRREGULAR;
	    }
	
		private int cumulativeDose;
		private Category category;
		private boolean hadCovid;
		
		private static final int DOSE_FOR_REGULAR = 100;
		private static final RandomGenerator RANDOM = RandomGenerator.getDefault();
		
	}	
	
	private enum Category { UNTREATED, IRREGULAR, REGULAR }		

}
