import module java.base;

public final class ExperimentalVerificationOfTheNKGtLawUsingNASAMercuryDataIn2025 {
	
	public static void main() {
		record MercuryData(String date, double position, double speed, double mass) {} // SI units: kg, m, s		
	
		// 1. NASA 2024 Reference Data
		
		MercuryData reference2024 = new MercuryData("31/12/2024", 4.64e10, 5.81e4, 3.30e23);

		final double pReference = reference2024.mass * reference2024.speed;
		final double nktg1 = reference2024.position * pReference;

		IO.println("\nNKTg₁ reference constant: " + nktg1);
		IO.println("=====================================\n");
		
		// 2. NASA 2025 Real Data
		
		List<MercuryData> nasa2025 = List.of(
		    new MercuryData("01/01/2025", 5.16e10, 5.34e4, 3.30e23),
		    new MercuryData("01/04/2025", 6.97e10, 3.89e4, 3.30e23),
		    new MercuryData("01/07/2025", 5.49e10, 5.04e4, 3.30e23),
		    new MercuryData("01/10/2025", 6.83e10, 3.98e4, 3.30e23),
		    new MercuryData("31/12/2025", 4.61e10, 5.89e4, 3.30e23)
		);
		
		// Mass variation rate (MESSENGER data)
		double dm_dt = -0.5; // kg/s

		IO.println("Date             v_NKTg         v_NASA      Rel. Error(%)    NKTg₂");
		IO.println("---------------------------------------------------------------------");
		
		nasa2025.forEach( data -> {
		    // Interpolated velocity from constant NKTg1
		    final double v_nktg = nktg1 / ( data.position * data.mass );

		    // Relative error
		    final double relativeError = ( ( v_nktg - data.speed ) / data.speed ) * 100.0;

		    // Momentum
		    final double p = data.mass * v_nktg;

		    // NKTg2 calculation
		    final double nktg2 = dm_dt * p;
		
		    IO.println("%-12s %12.3e %14.3e %12.4f %15.3e"
		    	.formatted(data.date, v_nktg, data.speed, relativeError, nktg2));		
		} );
	}

}
