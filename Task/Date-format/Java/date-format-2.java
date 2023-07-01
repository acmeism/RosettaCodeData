import java.util.Calendar;
import java.util.GregorianCalendar;
import java.text.DateFormatSymbols;
import java.text.DateFormat;
public class Dates{
 public static void main(String[] args){
  Calendar now = new GregorianCalendar(); //months are 0 indexed, dates are 1 indexed
  DateFormatSymbols symbols = new DateFormatSymbols(); //names for our months and weekdays

  //plain numbers way
  System.out.println(now.get(Calendar.YEAR)  + "-" + (now.get(Calendar.MONTH) + 1) + "-" + now.get(Calendar.DATE));

  //words way
  System.out.print(symbols.getWeekdays()[now.get(Calendar.DAY_OF_WEEK)] + ", ");
  System.out.print(symbols.getMonths()[now.get(Calendar.MONTH)] + " ");
  System.out.println(now.get(Calendar.DATE) + ", " + now.get(Calendar.YEAR));
 }
}
