import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.TimeZone;

public class NauticalBell extends Thread {

    public static void main(String[] args) {
        NauticalBell bells = new NauticalBell();
        bells.setDaemon(true);
        bells.start();
        try {
            bells.join();
        } catch (InterruptedException e) {
            System.out.println(e);
        }
    }

    @Override
    public void run() {
        DateFormat sdf = new SimpleDateFormat("HH:mm:ss");
        sdf.setTimeZone(TimeZone.getTimeZone("UTC"));

        int numBells = 0;
        long time = System.currentTimeMillis();
        long next = time - (time % (24 * 60 * 60 * 1000)); // midnight

        while (next < time) {
            next += 30 * 60 * 1000; // 30 minutes
            numBells = 1 + (numBells % 8);
        }

        while (true) {
            long wait = 100L;
            time = System.currentTimeMillis();
            if (time - next >= 0) {
                String bells = numBells == 1 ? "bell" : "bells";
                String timeString = sdf.format(time);
                System.out.printf("%s : %d %s\n", timeString, numBells, bells);
                next += 30 * 60 * 1000;
                wait = next - time;
                numBells = 1 + (numBells % 8);
            }
            try {
                Thread.sleep(wait);
            } catch (InterruptedException e) {
                return;
            }
        }
    }
}
