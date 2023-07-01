import java.util.function.DoubleSupplier;

public class ManOrBoy {

    static double A(int k, DoubleSupplier x1, DoubleSupplier x2,
                 DoubleSupplier x3, DoubleSupplier x4, DoubleSupplier x5) {

        DoubleSupplier B = new DoubleSupplier() {
            int m = k;
            public double getAsDouble() {
                return A(--m, this, x1, x2, x3, x4);
            }
        };

        return k <= 0 ? x4.getAsDouble() + x5.getAsDouble() : B.getAsDouble();
    }

    public static void main(String[] args) {
        System.out.println(A(10, () -> 1.0, () -> -1.0, () -> -1.0, () -> 1.0, () -> 0.0));
    }
}
