import module java.base;

public final class ExperimentalVerificationOfNASA2025EarthDataset {

	public static void main() {
		// Simulated NKTg 2025 dataset
	    List<OrbitalData> simulated2025 = List.of(
	        new OrbitalData( "1/1/2025",   1.471012e11, 3.0276e4, 5.97219e24 ),
	        new OrbitalData( "4/1/2025",   1.494953e11, 2.9791e4, 5.97218999999998e24 ),
	        new OrbitalData( "7/1/2025",   1.520965e11, 2.9282e4, 5.97218999999997e24 ),
	        new OrbitalData( "10/1/2025",  1.496328e11, 2.9764e4, 5.97218999999995e24 ),
	        new OrbitalData( "12/31/2025", 1.471025e11, 3.0276e4, 5.97218999999994e24 )
	    );
	
		// NASA observed speeds
		List<Observation> nasa2025 = List.of(
		    new Observation( "1/1/2025", 3.0287e4 ),
		    new Observation( "4/1/2025", 2.9791e4 ),
		    new Observation( "7/1/2025", 2.9291e4 ),
		    new Observation( "10/1/2025", 2.9778e4 ),
		    new Observation( "12/31/2025", 3.0286e4 )
		);
		
		IO.println("\nExperimental Verification of NKTg Law (Earth 2025)\n");
		
		IO.println("%-10s %14s %14s %15s %14s %14s %12s"
			.formatted("Date", "Momentum(p)", "NKTg1", "NKTg2", "v_sim", "v_NASA", "Error"));
		IO.println("-".repeat(99));
		
		int index = 0;
		for ( OrbitalData data : simulated2025 ) {
			final double p = momentum.apply(data.m, data.v);
		    final double n1 = nktg1.apply(data.x, p);
		    final double n2 = nktg2.apply(p);

		    final double v_nasa = nasa2025.get(index++).v;
		    final double error = relativeError.apply(data.v, v_nasa);

		    IO.println("%-10s %14.3e %14.3e %15.3e %14.3e %14.3e %12.4f"
		    	.formatted(data.date, p, n1, n2, data.v, v_nasa, error));			
		}		
	}
	
	private record OrbitalData(String date, double x, double v, double m) {}
	
	private record Observation(String date, double v) {}
	
	private static final Double DM_DT = - 1.8; // kg/s
	
	private static BiFunction<Double, Double, Double> momentum = (m, v) -> m * v;

	private static BiFunction<Double, Double, Double> nktg1 = (x, p) -> x * p;
	
	private static Function<Double, Double> nktg2 = p -> DM_DT * p;

	private static BiFunction<Double, Double, Double> relativeError =
		(sim, nasa) -> ( ( sim - nasa ) / nasa ) * 100.0;	

}
