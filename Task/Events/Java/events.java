import java.util.Timer;
import java.util.TimerTask;
import java.util.Date;

public class Main {
    public static void main(String[] args) {
        Timer timer = new Timer();
        TimerTask task = new TimerTask() {
            @Override
            public void run() {
                System.out.println(new Date());
                timer.cancel();
            }
        };
        System.out.println(new Date());
        timer.schedule(task, 1000);
    }
}
