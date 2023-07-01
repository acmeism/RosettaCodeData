import java.math.BigInteger;
import java.time.Duration;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class Program {
    static final String ALPHABET = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz|";
    static byte base, bmo, blim, ic;
    static long st0;
    static BigInteger bllim, threshold;
    static Set<Byte> hs = new HashSet<>();
    static Set<Byte> o = new HashSet<>();
    static final char[] chars = ALPHABET.toCharArray();
    static List<BigInteger> limits;
    static String ms;

    static int indexOf(char c) {
        for (int i = 0; i < chars.length; ++i) {
            if (chars[i] == c) {
                return i;
            }
        }
        return -1;
    }

    // convert BigInteger to string using current base
    static String toStr(BigInteger b) {
        BigInteger bigBase = BigInteger.valueOf(base);
        StringBuilder res = new StringBuilder();
        while (b.compareTo(BigInteger.ZERO) > 0) {
            BigInteger[] divRem = b.divideAndRemainder(bigBase);
            res.append(chars[divRem[1].intValue()]);
            b = divRem[0];
        }
        return res.toString();
    }

    // check for a portion of digits, bailing if uneven
    static boolean allInQS(BigInteger b) {
        BigInteger bigBase = BigInteger.valueOf(base);
        int c = ic;
        hs.clear();
        hs.addAll(o);
        while (b.compareTo(bllim) > 0) {
            BigInteger[] divRem = b.divideAndRemainder(bigBase);
            hs.add(divRem[1].byteValue());
            c++;

            if (c > hs.size()) {
                return false;
            }
            b = divRem[0];
        }
        return true;
    }

    // check for a portion of digits, all the way to the end
    static boolean allInS(BigInteger b) {
        BigInteger bigBase = BigInteger.valueOf(base);
        hs.clear();
        hs.addAll(o);
        while (b.compareTo(bllim) > 0) {
            BigInteger[] divRem = b.divideAndRemainder(bigBase);
            hs.add(divRem[1].byteValue());
            b = divRem[0];
        }
        return hs.size() == base;
    }

    // check for all digits, bailing if uneven
    static boolean allInQ(BigInteger b) {
        BigInteger bigBase = BigInteger.valueOf(base);
        int c = 0;
        hs.clear();
        while (b.compareTo(BigInteger.ZERO) > 0) {
            BigInteger[] divRem = b.divideAndRemainder(bigBase);
            hs.add(divRem[1].byteValue());
            c++;
            if (c > hs.size()) {
                return false;
            }
            b = divRem[0];
        }
        return true;
    }

    // check for all digits, all the way to the end
    static boolean allIn(BigInteger b) {
        BigInteger bigBase = BigInteger.valueOf(base);
        hs.clear();
        while (b.compareTo(BigInteger.ZERO) > 0) {
            BigInteger[] divRem = b.divideAndRemainder(bigBase);
            hs.add(divRem[1].byteValue());
            b = divRem[0];
        }
        return hs.size() == base;
    }

    // parse a string into a BigInteger, using current base
    static BigInteger to10(String s) {
        BigInteger bigBase = BigInteger.valueOf(base);
        BigInteger res = BigInteger.ZERO;
        for (int i = 0; i < s.length(); ++i) {
            char c = s.charAt(i);
            int idx = indexOf(c);
            BigInteger bigIdx = BigInteger.valueOf(idx);
            res = res.multiply(bigBase).add(bigIdx);
        }
        return res;
    }

    // returns the minimum value string, optionally inserting extra digit
    static String fixup(int n) {
        String res = ALPHABET.substring(0, base);
        if (n > 0) {
            StringBuilder sb = new StringBuilder(res);
            sb.insert(n, n);
            res = sb.toString();
        }
        return "10" + res.substring(2);
    }

    // checks the square against the threshold, advances various limits when needed
    static void check(BigInteger sq) {
        if (sq.compareTo(threshold) > 0) {
            o.remove((byte) indexOf(ms.charAt(blim)));
            blim--;
            ic--;
            threshold = limits.get(bmo - blim - 1);
            bllim = to10(ms.substring(0, blim + 1));
        }
    }

    // performs all the calculations for the current base
    static void doOne() {
        limits = new ArrayList<>();
        bmo = (byte) (base - 1);
        byte dr = 0;
        if ((base & 1) == 1) {
            dr = (byte) (base >> 1);
        }
        o.clear();
        blim = 0;
        byte id = 0;
        int inc = 1;
        long st = System.nanoTime();
        byte[] sdr = new byte[bmo];
        byte rc = 0;
        for (int i = 0; i < bmo; i++) {
            sdr[i] = (byte) ((i * i) % bmo);
            rc += sdr[i] == dr ? (byte) 1 : (byte) 0;
            sdr[i] += sdr[i] == 0 ? bmo : (byte) 0;
        }
        long i = 0;
        if (dr > 0) {
            id = base;
            for (i = 1; i <= dr; i++) {
                if (sdr[(int) i] >= dr) {
                    if (id > sdr[(int) i]) {
                        id = sdr[(int) i];
                    }
                }
            }
            id -= dr;
            i = 0;
        }
        ms = fixup(id);
        BigInteger sq = to10(ms);
        BigInteger rt = BigInteger.valueOf((long) (Math.sqrt(sq.doubleValue()) + 1));
        sq = rt.multiply(rt);
        if (base > 9) {
            for (int j = 1; j < base; j++) {
                limits.add(to10(ms.substring(0, j) + String.valueOf(chars[bmo]).repeat(base - j + (rc > 0 ? 0 : 1))));
            }
            Collections.reverse(limits);
            while (sq.compareTo(limits.get(0)) < 0) {
                rt = rt.add(BigInteger.ONE);
                sq = rt.multiply(rt);
            }
        }
        BigInteger dn = rt.shiftLeft(1).add(BigInteger.ONE);
        BigInteger d = BigInteger.ONE;
        if (base > 3 && rc > 0) {
            while (sq.remainder(BigInteger.valueOf(bmo)).compareTo(BigInteger.valueOf(dr)) != 0) {
                rt = rt.add(BigInteger.ONE);
                sq = sq.add(dn);
                dn = dn.add(BigInteger.TWO);
            } // aligns sq to dr
            inc = bmo / rc;
            if (inc > 1) {
                dn = dn.add(rt.multiply(BigInteger.valueOf(inc - 2)).subtract(BigInteger.ONE));
                d = BigInteger.valueOf(inc * inc);
            }
            dn = dn.add(dn).add(d);
        }
        d = d.shiftLeft(1);
        if (base > 9) {
            blim = 0;
            while (sq.compareTo(limits.get(bmo - blim - 1)) < 0) {
                blim++;
            }
            ic = (byte) (blim + 1);
            threshold = limits.get(bmo - blim - 1);
            if (blim > 0) {
                for (byte j = 0; j <= blim; j++) {
                    o.add((byte) indexOf(ms.charAt(j)));
                }
            }
            if (blim > 0) {
                bllim = to10(ms.substring(0, blim + 1));
            } else {
                bllim = BigInteger.ZERO;
            }
            if (base > 5 && rc > 0)
                while (!allInQS(sq)) {
                    sq = sq.add(dn);
                    dn = dn.add(d);
                    i += 1;
                    check(sq);
                }
            else {
                while (!allInS(sq)) {
                    sq = sq.add(dn);
                    dn = dn.add(d);
                    i += 1;
                    check(sq);
                }
            }
        } else {
            if (base > 5 && rc > 0) {
                while (!allInQ(sq)) {
                    sq = sq.add(dn);
                    dn = dn.add(d);
                    i += 1;
                }
            } else {
                while (!allIn(sq)) {
                    sq = sq.add(dn);
                    dn = dn.add(d);
                    i += 1;
                }
            }
        }

        rt = rt.add(BigInteger.valueOf(i * inc));
        long delta1 = System.nanoTime() - st;
        Duration dur1 = Duration.ofNanos(delta1);
        long delta2 = System.nanoTime() - st0;
        Duration dur2 = Duration.ofNanos(delta2);
        System.out.printf(
            "%3d  %2d  %2s %20s -> %-40s %10d %9s  %9s\n",
            base, inc, (id > 0 ? ALPHABET.substring(id, id + 1) : " "), toStr(rt), toStr(sq), i, format(dur1), format(dur2)
        );
    }

    private static String format(Duration d) {
        int minP = d.toMinutesPart();
        int secP = d.toSecondsPart();
        int milP = d.toMillisPart();
        return String.format("%02d:%02d.%03d", minP, secP, milP);
    }

    public static void main(String[] args) {
        System.out.println("base inc id                 root    square                                   test count    time        total");
        st0 = System.nanoTime();
        for (base = 2; base < 28; ++base) {
            doOne();
        }
    }
}
