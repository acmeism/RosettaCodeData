import module java.base;

public final class ExperimentalVerificationOfTheNKTgLawUsingNasaNeptuneData {

	public static void main() {
		// 2023 NASA Data (Neptune)
		final double dmdt = -0.00002000; // kg/s (micro gas loss assumption)
		
		// 2024 NASA Actual Mass of Neptune
		final double nasaMass2024 = 1.02430000e26; // kg
		
		record Data(String date, double position, double speed, double mass) {} // SI units: kg, m, s
		
		Consumer<Data> computeNKTg = data -> {
		    final double p = data.mass * data.speed;
		    final double nktg1 = data.position * p;
		    final double nktg2 = dmdt * p;
		    final double nktg = Math.sqrt( nktg1 * nktg1 + nktg2 * nktg2 );

		    IO.println("--------------------------------------------");
		    IO.println("Position (x)         : " + data.position);
		    IO.println("Velocity (v)         : " + data.speed);
		    IO.println("Mass (m)             : " + data.mass);
		    IO.println("Momentum (p = m * v) : " + p);
		    IO.println("NKTg1 = x * p        : " + nktg1);
		    IO.println("NKTg2 = dm_dt * p    : " + nktg2);
		    IO.println("Total NKTg           : " + nktg);
		};
		
		IO.println("\n==== NKTg Law - Neptune 2023 NASA Data ====");
		
		List<Data> data2023 = List.of(
            new Data("2023-01-01", 4498396440.0, 5.43, 1.02430000e26),
            new Data("2023-04-01", 4503443661.0, 5.43, 1.02429980e26),
            new Data("2023-07-01", 4553946490.0, 5.43, 1.02429960e26),
            new Data("2023-10-01",4503443661.0, 5.43, 1.02429940e26),
            new Data("2023-12-31", 4498396440.0, 5.43, 1.02429920e26)
        );
		
		data2023.forEach( data -> computeNKTg.accept(data) );
		
		IO.println("\n==== NKTg Law - Neptune 2024 Simulation ====");

		List<Data> data2024 = List.of(
		    new Data("2023-01-01", 4498396440.0, 5.43, 1.02429900e26),
		    new Data("2023-04-01", 4503443661.0, 5.43, 1.02429880e26),
		    new Data("2023-07-01", 4553946490.0, 5.43, 1.02429860e26),
		    new Data("2023-10-01", 4503443661.0, 5.43, 1.02429840e26),
		    new Data("2023-12-31", 4498396440.0, 5.43, 1.02429820e26)
		);
		
		data2024.forEach( data -> computeNKTg.accept(data) );
		
		IO.println("\n==== Relative Mass Error 2024 (%) ====");
		
		data2024.forEach( data -> {
			final double error = Math.abs(100.0 * ( data.mass - nasaMass2024 ) / nasaMass2024);
			IO.println(data.date + ": %.8f".formatted(error));
		} );
	}

}
