import java.time.ZonedDateTime;

public class SystemTime{
   public static void main(String[] args){
      var now = ZonedDateTime.now();
      System.out.println(now);
   }
}
