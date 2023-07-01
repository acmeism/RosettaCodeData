import java.util.Arrays;
import java.util.concurrent.ThreadLocalRandom;

public class AtomicUpdates {

    private static final int NUM_BUCKETS = 10;

    public static class Buckets {
        private final int[] data;

        public Buckets(int[] data) {
            this.data = data.clone();
        }

        public int getBucket(int index) {
            synchronized (data) {
                return data[index];
            }
        }

        public int transfer(int srcIndex, int dstIndex, int amount) {
            if (amount < 0)
                throw new IllegalArgumentException("negative amount: " + amount);
            if (amount == 0)
                return 0;

            synchronized (data) {
                if (data[srcIndex] - amount < 0)
                    amount = data[srcIndex];
                if (data[dstIndex] + amount < 0)
                    amount = Integer.MAX_VALUE - data[dstIndex];
                if (amount < 0)
                    throw new IllegalStateException();
                data[srcIndex] -= amount;
                data[dstIndex] += amount;
                return amount;
            }
        }

        public int[] getBuckets() {
            synchronized (data) {
                return data.clone();
            }
        }
    }

    private static long getTotal(int[] values) {
        long total = 0;
        for (int value : values) {
            total += value;
        }
        return total;
    }

    public static void main(String[] args) {
        ThreadLocalRandom rnd = ThreadLocalRandom.current();

        int[] values = new int[NUM_BUCKETS];
        for (int i = 0; i < values.length; i++)
            values[i] = rnd.nextInt() & Integer.MAX_VALUE;
        System.out.println("Initial Array: " + getTotal(values) + " " + Arrays.toString(values));

        Buckets buckets = new Buckets(values);
        new Thread(() -> equalize(buckets), "equalizer").start();
        new Thread(() -> transferRandomAmount(buckets), "transferrer").start();
        new Thread(() -> print(buckets), "printer").start();
    }

    private static void transferRandomAmount(Buckets buckets) {
        ThreadLocalRandom rnd = ThreadLocalRandom.current();
        while (true) {
            int srcIndex = rnd.nextInt(NUM_BUCKETS);
            int dstIndex = rnd.nextInt(NUM_BUCKETS);
            int amount = rnd.nextInt() & Integer.MAX_VALUE;
            buckets.transfer(srcIndex, dstIndex, amount);
        }
    }

    private static void equalize(Buckets buckets) {
        ThreadLocalRandom rnd = ThreadLocalRandom.current();
        while (true) {
            int srcIndex = rnd.nextInt(NUM_BUCKETS);
            int dstIndex = rnd.nextInt(NUM_BUCKETS);
            int amount = (buckets.getBucket(srcIndex) - buckets.getBucket(dstIndex)) / 2;
            if (amount >= 0)
                buckets.transfer(srcIndex, dstIndex, amount);
        }
    }

    private static void print(Buckets buckets) {
        while (true) {
            long nextPrintTime = System.currentTimeMillis() + 3000;
            long now;
            while ((now = System.currentTimeMillis()) < nextPrintTime) {
                try {
                    Thread.sleep(nextPrintTime - now);
                } catch (InterruptedException e) {
                    return;
                }
            }

            int[] bucketValues = buckets.getBuckets();
            System.out.println("Current values: " + getTotal(bucketValues) + " " + Arrays.toString(bucketValues));
        }
    }
}
