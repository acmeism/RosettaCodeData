public class Accumulator {
    private double sum;
    public Accumulator(double sum0) {
        sum = sum0;
    }
    public double call(double n) {
        return sum += n;
    }

    public static void main(String[] args) {
        Accumulator x = new Accumulator(1);
        x.call(5);
        System.out.println(new Accumulator(3));
        System.out.println(x.call(2.3));
    }
}
