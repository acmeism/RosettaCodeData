import java.math.BigInteger;
import java.util.PriorityQueue;

final class Hamming {
    private static BigInteger THREE = BigInteger.valueOf(3);
    private static BigInteger FIVE = BigInteger.valueOf(5);

    private static void updateFrontier(BigInteger x,
                                       PriorityQueue<BigInteger> pq) {
        pq.offer(x.shiftLeft(1));
        pq.offer(x.multiply(THREE));
        pq.offer(x.multiply(FIVE));
    }

    public static BigInteger hamming(int n) {
        if (n <= 0)
            throw new IllegalArgumentException("Invalid parameter");
        PriorityQueue<BigInteger> frontier = new PriorityQueue<BigInteger>();
        updateFrontier(BigInteger.ONE, frontier);
        BigInteger lowest = BigInteger.ONE;
        for (int i = 1; i < n; i++) {
            lowest = frontier.poll();
            while (frontier.peek().equals(lowest))
                frontier.poll();
            updateFrontier(lowest, frontier);
        }
        return lowest;
    }

    public static void main(String[] args) {
        System.out.print("Hamming(1 .. 20) =");
        for (int i = 1; i < 21; i++)
             System.out.print(" " + hamming(i));
        System.out.println("\nHamming(1691) = " + hamming(1691));
        System.out.println("Hamming(1000000) = " + hamming(1000000));
    }
}
