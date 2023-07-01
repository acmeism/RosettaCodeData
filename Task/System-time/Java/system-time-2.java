import java.util.Date;

public class SystemTime{
   public static void main(String[] args){
      Date now = new Date();
      System.out.println(now); // string representation

      System.out.println(now.getTime()); // Unix time (# of milliseconds since Jan 1 1970)
      //System.currentTimeMillis() returns the same value
   }
}
