import java.util.List;

public class Zeckendorf implements Comparable<Zeckendorf> {
    private static List<String> dig = List.of("00", "01", "10");
    private static List<String> dig1 = List.of("", "1", "10");

    private String x;
    private int dVal = 0;
    private int dLen = 0;

    public Zeckendorf() {
        this("0");
    }

    public Zeckendorf(String x) {
        this.x = x;

        int q = 1;
        int i = x.length() - 1;
        dLen = i / 2;
        while (i >= 0) {
            dVal += (x.charAt(i) - '0') * q;
            q *= 2;
            i--;
        }
    }

    private void a(int n) {
        int i = n;
        while (true) {
            if (dLen < i) dLen = i;
            int j = (dVal >> (i * 2)) & 3;
            switch (j) {
                case 0:
                case 1:
                    return;
                case 2:
                    if (((dVal >> ((i + 1) * 2)) & 1) != 1) return;
                    dVal += 1 << (i * 2 + 1);
                    return;
                case 3:
                    int temp = 3 << (i * 2);
                    temp ^= -1;
                    dVal = dVal & temp;
                    b((i + 1) * 2);
                    break;
            }
            i++;
        }
    }

    private void b(int pos) {
        if (pos == 0) {
            Zeckendorf thiz = this;
            thiz.inc();
            return;
        }
        if (((dVal >> pos) & 1) == 0) {
            dVal += 1 << pos;
            a(pos / 2);
            if (pos > 1) a(pos / 2 - 1);
        } else {
            int temp = 1 << pos;
            temp ^= -1;
            dVal = dVal & temp;
            b(pos + 1);
            b(pos - (pos > 1 ? 2 : 1));
        }
    }

    private void c(int pos) {
        if (((dVal >> pos) & 1) == 1) {
            int temp = 1 << pos;
            temp ^= -1;
            dVal = dVal & temp;
            return;
        }
        c(pos + 1);
        if (pos > 0) {
            b(pos - 1);
        } else {
            Zeckendorf thiz = this;
            thiz.inc();
        }
    }

    public Zeckendorf inc() {
        dVal++;
        a(0);
        return this;
    }

    public void plusAssign(Zeckendorf other) {
        for (int gn = 0; gn < (other.dLen + 1) * 2; gn++) {
            if (((other.dVal >> gn) & 1) == 1) {
                b(gn);
            }
        }
    }

    public void minusAssign(Zeckendorf other) {
        for (int gn = 0; gn < (other.dLen + 1) * 2; gn++) {
            if (((other.dVal >> gn) & 1) == 1) {
                c(gn);
            }
        }
        while ((((dVal >> dLen * 2) & 3) == 0) || (dLen == 0)) {
            dLen--;
        }
    }

    public void timesAssign(Zeckendorf other) {
        Zeckendorf na = other.copy();
        Zeckendorf nb = other.copy();
        Zeckendorf nt;
        Zeckendorf nr = new Zeckendorf();
        for (int i = 0; i < (dLen + 1) * 2; i++) {
            if (((dVal >> i) & 1) > 0) {
                nr.plusAssign(nb);
            }
            nt = nb.copy();
            nb.plusAssign(na);
            na = nt.copy();
        }
        dVal = nr.dVal;
        dLen = nr.dLen;
    }

    private Zeckendorf copy() {
        Zeckendorf z = new Zeckendorf();
        z.dVal = dVal;
        z.dLen = dLen;
        return z;
    }

    @Override
    public int compareTo(Zeckendorf other) {
        return ((Integer) dVal).compareTo(other.dVal);
    }

    @Override
    public String toString() {
        if (dVal == 0) {
            return "0";
        }

        int idx = (dVal >> (dLen * 2)) & 3;
        StringBuilder stringBuilder = new StringBuilder(dig1.get(idx));
        for (int i = dLen - 1; i >= 0; i--) {
            idx = (dVal >> (i * 2)) & 3;
            stringBuilder.append(dig.get(idx));
        }
        return stringBuilder.toString();
    }

    public static void main(String[] args) {
        System.out.println("Addition:");
        Zeckendorf g = new Zeckendorf("10");
        g.plusAssign(new Zeckendorf("10"));
        System.out.println(g);
        g.plusAssign(new Zeckendorf("10"));
        System.out.println(g);
        g.plusAssign(new Zeckendorf("1001"));
        System.out.println(g);
        g.plusAssign(new Zeckendorf("1000"));
        System.out.println(g);
        g.plusAssign(new Zeckendorf("10101"));
        System.out.println(g);

        System.out.println("\nSubtraction:");
        g = new Zeckendorf("1000");
        g.minusAssign(new Zeckendorf("101"));
        System.out.println(g);
        g = new Zeckendorf("10101010");
        g.minusAssign(new Zeckendorf("1010101"));
        System.out.println(g);

        System.out.println("\nMultiplication:");
        g = new Zeckendorf("1001");
        g.timesAssign(new Zeckendorf("101"));
        System.out.println(g);
        g = new Zeckendorf("101010");
        g.plusAssign(new Zeckendorf("101"));
        System.out.println(g);
    }
}
