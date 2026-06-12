import java.util.function.IntBinaryOperator;

public class Nimber {
    public static void main(String[] args) {
        printTable(15, '+', (x, y) -> nimSum(x, y));
        System.out.println();
        printTable(15, '*', (x, y) -> nimProduct(x, y));
        System.out.println();

        int a = 21508, b = 42689;
        System.out.println(a + " + " + b +  " = " + nimSum(a, b));
        System.out.println(a + " * " + b +  " = " + nimProduct(a, b));
    }

    // nim-sum of two numbers
    public static int nimSum(int x, int y) {
        return x ^ y;
    }

    // nim-product of two numbers
    public static int nimProduct(int x, int y) {
        if (x < 2 || y < 2)
            return x * y;
        int h = hpo2(x);
        if (x > h)
            return nimProduct(h, y) ^ nimProduct(x ^ h, y);
        if (hpo2(y) < y)
            return nimProduct(y, x);
        int xp = lhpo2(x), yp = lhpo2(y);
        int comp = xp & yp;
        if (comp == 0)
            return x * y;
        h = hpo2(comp);
        return nimProduct(nimProduct(x >> h, y >> h), 3 << (h - 1));
    }

    // highest power of 2 that divides a given number
    private static int hpo2(int n) {
        return n & -n;
    }

    // base 2 logarithm of the highest power of 2 dividing a given number
    private static int lhpo2(int n) {
        int q = 0, m = hpo2(n);
        for (; m % 2 == 0; m >>= 1, ++q) {}
        return q;
    }

    private static void printTable(int n, char op, IntBinaryOperator func) {
        System.out.print(" " + op + " |");
        for (int a = 0; a <= n; ++a)
            System.out.printf("%3d", a);
        System.out.print("\n--- -");
        for (int a = 0; a <= n; ++a)
            System.out.print("---");
        System.out.println();
        for (int b = 0; b <= n; ++b) {
            System.out.printf("%2d |", b);
            for (int a = 0; a <= n; ++a)
                System.out.printf("%3d", func.applyAsInt(a, b));
            System.out.println();
        }
    }
}
