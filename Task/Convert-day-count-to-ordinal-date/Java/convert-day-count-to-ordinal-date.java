import module java.base;

public final class ConvertDayCountToOrdinalDate {

	public static void main() {
		// Day count from ISO Date 0000-01-01 to 1970-01-01
		final int offset = -146097 * 5 + 30 * 365 + 7;

		List.of( 0, 109_573, 146_096 ).forEach( dayCount -> {
			IO.println("Day count: %d".formatted(dayCount) );
			IntStream.range(0, 6).forEach( i -> {
				LocalDate date = LocalDate.ofEpochDay(i * 146097 + dayCount + offset);
				IO.println("%2d/%2d/%4d" // Convert ISO format date to the task required format
					.formatted(date.getDayOfMonth(), date.getMonthValue(), date.getYear()).replace(" ", "0") );
			} );
			IO.println();
		} );
	}

}
