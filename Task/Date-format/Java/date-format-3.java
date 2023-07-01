import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
public class Dates
{
 public static void main(final String[] args)
 {
  //using DateTimeFormatter
  LocalDate date = LocalDate.now();
  DateTimeFormatter dtFormatter = DateTimeFormatter.ofPattern("yyyy MM dd");

  System.out.println(dtFormatter.format(date));
 }
}
