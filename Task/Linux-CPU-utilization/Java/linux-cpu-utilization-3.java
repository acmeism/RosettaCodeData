import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.text.NumberFormat;
import java.time.Duration;
import java.util.Timer;
import java.util.TimerTask;

/* Idiomatic Java
 *This certainly could've been done much shorter, but I'm glad with the way it came out
 * */
public class Main {

    public static void main(String[] args) throws FileNotFoundException {
        // this demonstrates the use of Duration class
        final var period = Duration.ofSeconds(1);
        new Timer().schedule(new CpuUtilizationTask(), 0, period.toMillis());
    }

    /* By extending the TimerTask abstract class, we're able to use the
     * Timer scheduling class */
    static class CpuUtilizationTask extends TimerTask {

        private final String STAT_FILE_HEADER = "cpu  ";
        private final NumberFormat percentFormatter;
        private final RandomAccessFile statPointer;
        long previousIdleTime = 0, previousTotalTime = 0;

        public CpuUtilizationTask() throws FileNotFoundException {
            this.percentFormatter = NumberFormat.getPercentInstance();
            percentFormatter.setMaximumFractionDigits(2);
            var statFile = new File("/proc/stat");
            /* by using the RandomAcessFile, we're able to keep an open file stream for
             * as long as this object lives, making further file openings unnecessary */
            this.statPointer = new RandomAccessFile(statFile, "r");
        }

        @Override
        public void run() {

            try {
                var values = statPointer.readLine()
                        .substring(STAT_FILE_HEADER.length())
                        .split(" ");

                /* because Java doesn't have unsigned primitive types, we have to use the boxed
                 * Long's parseUsigned method. It does what it says it does.
                 * The rest of the arithmetic can go on as normal.
                 * I've seen solutions reading the value as integers. They're NOT!*/
                var idleTime = Long.parseUnsignedLong(values[3]);
                var totalTime = 0L;
                for (String value : values) {
                    totalTime += Long.parseUnsignedLong(value);
                }

                var idleTimeDelta = idleTime - previousIdleTime;
                var totalTimeDelta = totalTime - previousTotalTime;
                var utilization = 1 - ((double) idleTimeDelta) / totalTimeDelta;

                /* Again, this is showing one more advantage of doing idiomatic Java
                 * we're doing locale aware percentage formatting */
                System.out.println(percentFormatter.format(utilization));

                previousIdleTime = idleTime;
                previousTotalTime = totalTime;

                // take us back to the beginning of the file, so we don't have to reopen it
                statPointer.seek(0);
            } catch (IOException ioException) {
                ioException.printStackTrace();
            }
        }

    }
}
