import module java.base;

public final class PiTo1MillionDigits {

	public static void main() {
		IO.println(
			"Calculating pi, from the Schönhage-Grotefeld-Vetter formula, using only the standard Java language");
		
		Instant start = Instant.now();
		String pi = calculatePi().toPlainString();
		Instant end = Instant.now();
		Duration interval = Duration.between(start, end);
		
		IO.println(pi.substring(0, 30) + " ... " + pi.substring(999_971, 1_000_001));
		IO.println("Time taken = " + interval.toSeconds() + " seconds");
	}
	
	private static BigDecimal calculatePi() {
		BigDecimal a = BigDecimal.ONE;
		BigDecimal b = BigDecimal.ONE.divide(BigDecimal.TWO.sqrt(mathContext), mathContext);
		BigDecimal t = new BigDecimal(0.25, mathContext);
		BigDecimal p = BigDecimal.ONE;		
		BigDecimal an = BigDecimal.ZERO;
		BigDecimal diff = BigDecimal.ZERO;
		
		while ( a.subtract(b).abs().compareTo(EPSILON) > 0 ) {
			an = a.add(b).divide(BigDecimal.TWO, mathContext);
			b = a.multiply(b).sqrt(mathContext);
			diff = a.subtract(an);
			t = t.subtract(p.multiply(diff).multiply(diff));
			a = an;
			p = p.multiply(BigDecimal.TWO);
		}
		
		return a.add(b).pow(2).divide(FOUR.multiply(t), mathContext);
	}	
	
	private static final BigDecimal EPSILON = BigDecimal.ONE.movePointLeft(1_000_001);
	private static final MathContext mathContext = new MathContext(1_000_001);
	private static final BigDecimal FOUR = new BigDecimal(4, mathContext);

}
