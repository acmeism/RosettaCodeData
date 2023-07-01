import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public class PalindromeDates {

    public static void main(String[] args) {
        LocalDate date = LocalDate.of(2020, 2, 3);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
        DateTimeFormatter formatterDash = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        System.out.printf("First 15 palindrome dates after 2020-02-02 are:%n");
        for ( int count = 0 ; count < 15 ; date = date.plusDays(1) ) {
            String dateFormatted = date.format(formatter);
            if ( dateFormatted.compareTo(new StringBuilder(dateFormatted).reverse().toString()) == 0 ) {
                count++;
                System.out.printf("date = %s%n", date.format(formatterDash));
            }
        }
    }

}
