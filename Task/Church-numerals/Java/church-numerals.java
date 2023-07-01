package lvijay;

import java.util.concurrent.atomic.AtomicInteger;
import java.util.function.Function;

public class Church {
    public static interface ChurchNum extends Function<ChurchNum, ChurchNum> {
    }

    public static ChurchNum zero() {
        return f -> x -> x;
    }

    public static ChurchNum next(ChurchNum n) {
        return f -> x -> f.apply(n.apply(f).apply(x));
    }

    public static ChurchNum plus(ChurchNum a) {
        return b -> f -> x -> b.apply(f).apply(a.apply(f).apply(x));
    }

    public static ChurchNum pow(ChurchNum m) {
        return n -> m.apply(n);
    }

    public static ChurchNum mult(ChurchNum a) {
        return b -> f -> x -> b.apply(a.apply(f)).apply(x);
    }

    public static ChurchNum toChurchNum(int n) {
        if (n <= 0) {
            return zero();
        }
        return next(toChurchNum(n - 1));
    }

    public static int toInt(ChurchNum c) {
        AtomicInteger counter = new AtomicInteger(0);
        ChurchNum funCounter = f -> {
            counter.incrementAndGet();
            return f;
        };

        plus(zero()).apply(c).apply(funCounter).apply(x -> x);

        return counter.get();
    }

    public static void main(String[] args) {
        ChurchNum zero  = zero();
        ChurchNum three = next(next(next(zero)));
        ChurchNum four  = next(next(next(next(zero))));

        System.out.println("3+4=" + toInt(plus(three).apply(four))); // prints 7
        System.out.println("4+3=" + toInt(plus(four).apply(three))); // prints 7

        System.out.println("3*4=" + toInt(mult(three).apply(four))); // prints 12
        System.out.println("4*3=" + toInt(mult(four).apply(three))); // prints 12

        // exponentiation.  note the reversed order!
        System.out.println("3^4=" + toInt(pow(four).apply(three))); // prints 81
        System.out.println("4^3=" + toInt(pow(three).apply(four))); // prints 64

        System.out.println("  8=" + toInt(toChurchNum(8))); // prints 8
    }
}
