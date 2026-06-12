import java.util.Arrays;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.IntStream;

class Program {
    private static final Map<Integer, Integer> dict = new ConcurrentHashMap<>();
    private static int criticalValue = 1;
    private static final Object lockObject = new Object();

    public static void main(String[] args) {
        testSzymanski(20);
    }

    static int flag(int id) {
        return dict.computeIfAbsent(id, k -> 0);
    }

    static void runSzymanski(int id, int[] allszy) {
        int[] others = Arrays.stream(allszy).filter(t -> t != id).toArray();
        dict.put(id, 1); // Standing outside waiting room
        while (Arrays.stream(others).anyMatch(t -> flag(t) >= 3)) {
            Thread.yield();
        }
        dict.put(id, 3); // Standing in doorway
        if (Arrays.stream(others).anyMatch(t -> flag(t) == 1)) {
            dict.put(id, 2); // Waiting for other processes to enter
            while (!Arrays.stream(others).anyMatch(t -> flag(t) == 4)) {
                Thread.yield();
            }
        }
        dict.put(id, 4); // The door is closed
        for (int t : others) {
            if (t >= id) continue;
            while (flag(t) > 1) {
                Thread.yield();
            }
        }

        // critical section
        synchronized (lockObject) {
            criticalValue += id * 3;
            criticalValue /= 2;
            System.out.println("Thread " + id + " changed the critical value to " + criticalValue + ".");
        }
        // end critical section

        // Exit protocol
        for (int t : others) {
            if (t <= id) continue;
            while (!Arrays.asList(0, 1, 4).contains(flag(t))) {
                Thread.yield();
            }
        }
        dict.put(id, 0); // Leave. Reopen door if nobody is still in the waiting room
    }

    static void testSzymanski(int n) {
        int[] allszy = IntStream.rangeClosed(1, n).toArray();
        Thread[] threads = Arrays.stream(allszy)
                .mapToObj(i -> new Thread(() -> runSzymanski(i, allszy)))
                .toArray(Thread[]::new);

        for (Thread thread : threads) {
            thread.start();
        }

        try {
            for (Thread thread : threads) {
                thread.join();
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
