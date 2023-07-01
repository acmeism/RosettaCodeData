import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.DoubleSummaryStatistics;
import java.util.List;

public final class MergeAndAggregateDatasets {

	public static void main(String[] args) {
		List<Patient> patients = Arrays.asList(
			new Patient("1001", "Hopper"),
			new Patient("4004", "Wirth"),
			new Patient("3003", "Kemeny"),
			new Patient("2002", "Gosling"),
			new Patient("5005", "Kurtz") );

		List<Visit> visits = Arrays.asList(				
		    new Visit("2002", "2020-09-10", 6.8),
		    new Visit("1001", "2020-09-17", 5.5),
		    new Visit("4004", "2020-09-24", 8.4),
		    new Visit("2002", "2020-10-08", null),
		    new Visit("1001", ""          , 6.6),
		    new Visit("3003", "2020-11-12", null),
		    new Visit("4004", "2020-11-05", 7.0),
		    new Visit("1001", "2020-11-19", 5.3) );
		
		Collections.sort(patients, Comparator.comparing(Patient::patientID));		
		System.out.println("| PATIENT_ID | LASTNAME | LAST_VISIT | SCORE_SUM | SCORE_AVG |");		
	    for ( Patient patient : patients ) {	    	
	    	List<Visit> patientVisits = visits.stream().filter( v -> v.visitID == patient.patientID() ).toList();
	    	String lastVisit = patientVisits.stream()
	    		.map( v -> v.visitDate ).max(Comparator.naturalOrder()).orElseGet( () -> "   None   " );	    	
	    	DoubleSummaryStatistics statistics = patientVisits.stream()
	    		.filter( v -> v.score != null ).mapToDouble(Visit::score).summaryStatistics();	    		    	
	    	double scoreSum = statistics.getSum();
	    	double scoreAverage = statistics.getAverage();	    	
	    	String patientDetails = String.format("%12s%11s%13s%12.2f%12.2f",
	    		patient.patientID, patient.lastName, lastVisit, scoreSum, scoreAverage);	    	
	    	System.out.println(patientDetails);
	    }

        private static record Patient(String patientID, String lastName) {};
	    private static record Visit(String visitID, String visitDate, Double score) {};

	}

}
