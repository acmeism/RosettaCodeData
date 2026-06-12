public class PositConverter {
    private static final int NBITS = 8;
    private static final int ES = 2;
    private static final int NPAT = 1 << NBITS;
    private static final int USEED = 1 << (1 << ES);

    public static int x2p(double x) {
        int i, p;
        double e = 1 << (ES - 1);
        double y = Math.abs(x);

        if (y == 0) return 0;
        if (Double.isInfinite(y)) return 1 << (NBITS - 1);

        if (y >= 1) {
            p = 1;
            i = 2;
            while (y >= USEED && i < NBITS) {
                p = 2 * p + 1;
                y = y / USEED;
                i = i + 1;
            }
            p = 2 * p;
            i = i + 1;
        } else {
            p = 0;
            i = 1;
            while (y < 1 && i <= NBITS) {
                y = y * USEED;
                i = i + 1;
            }
            if (i >= NBITS) {
                p = 2;
                i = NBITS + 1;
            } else {
                p = 1;
                i = i + 1;
            }
        }

        while (e > 0.5 && i <= NBITS) {
            p = 2 * p;
            if (y >= 2 * e) {
                y = y / (1 << (int)e);
                p = p + 1;
            }
            e = e / 2;
            i = i + 1;
        }
        y = y - 1;

        while (y > 0 && i <= NBITS) {
            y = 2 * y;
            p = 2 * p + (int)Math.floor(y);
            y = y - Math.floor(y);
            i = i + 1;
        }

        p = p * (1 << (NBITS + 1 - i));
        i = i + 1;
        i = p & 1;
        p = (int)Math.floor(p / 2.0);

        if (i != 0) {
            if (y == 1 || y == 0) {
                p = p + (p & 1);
            } else {
                p = p + 1;
            }
        }

        return (x < 0 ? NPAT - p : p) % NPAT;
    }

    public static void main(String[] args) {
        System.out.println(x2p(Math.PI));
    }
}
