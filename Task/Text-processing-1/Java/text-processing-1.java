import java.io.File;
import java.util.*;
import static java.lang.System.out;

public class TextProcessing1 {

    public static void main(String[] args) throws Exception {
        Locale.setDefault(new Locale("en", "US"));
        Metrics metrics = new Metrics();

        int dataGap = 0;
        String gapBeginDate = null;
        try (Scanner lines = new Scanner(new File("readings.txt"))) {
            while (lines.hasNextLine()) {

                double lineTotal = 0.0;
                int linePairs = 0;
                int lineInvalid = 0;
                String lineDate;

                try (Scanner line = new Scanner(lines.nextLine())) {

                    lineDate = line.next();

                    while (line.hasNext()) {
                        final double value = line.nextDouble();
                        if (line.nextInt() <= 0) {
                            if (dataGap == 0)
                                gapBeginDate = lineDate;
                            dataGap++;
                            lineInvalid++;
                            continue;
                        }
                        lineTotal += value;
                        linePairs++;

                        metrics.addDataGap(dataGap, gapBeginDate, lineDate);
                        dataGap = 0;
                    }
                }
                metrics.addLine(lineTotal, linePairs);
                metrics.lineResult(lineDate, lineInvalid, linePairs, lineTotal);
            }
            metrics.report();
        }
    }

    private static class Metrics {
        private List<String[]> gapDates;
        private int maxDataGap = -1;
        private double total;
        private int pairs;
        private int lineResultCount;

        void addLine(double tot, double prs) {
            total += tot;
            pairs += prs;
        }

        void addDataGap(int gap, String begin, String end) {
            if (gap > 0 && gap >= maxDataGap) {
                if (gap > maxDataGap) {
                    maxDataGap = gap;
                    gapDates = new ArrayList<>();
                }
                gapDates.add(new String[]{begin, end});
            }
        }

        void lineResult(String date, int invalid, int prs, double tot) {
            if (lineResultCount >= 3)
                return;
            out.printf("%10s  out: %2d  in: %2d  tot: %10.3f  avg: %10.3f%n",
                    date, invalid, prs, tot, (prs > 0) ? tot / prs : 0.0);
            lineResultCount++;
        }

        void report() {
            out.printf("%ntotal    = %10.3f%n", total);
            out.printf("readings = %6d%n", pairs);
            out.printf("average  = %010.3f%n", total / pairs);
            out.printf("%nmaximum run(s) of %d invalid measurements: %n",
                    maxDataGap);
            for (String[] dates : gapDates)
                out.printf("begins at %s and ends at %s%n", dates[0], dates[1]);

        }
    }
}
