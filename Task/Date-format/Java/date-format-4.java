import java.text.SimpleDateFormat;
import java.util.Date;

public class DateFormat {
    public static void main(String[]args){
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat formatLong = new SimpleDateFormat("EEEE, MMMM dd, yyyy");
        System.out.println(format.format(new Date()));
        System.out.println(formatLong.format(new Date()));
    }
}
