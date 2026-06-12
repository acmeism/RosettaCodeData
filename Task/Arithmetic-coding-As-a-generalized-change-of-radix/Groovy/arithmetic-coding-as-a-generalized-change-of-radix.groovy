class ArithmeticCoding {
    private static class Triple<A, B, C> {
        A a
        B b
        C c

        Triple(A a, B b, C c) {
            this.a = a
            this.b = b
            this.c = c
        }
    }

    private static class Freq extends HashMap<Character, Long> {
        // type alias
    }

    private static Freq cumulativeFreq(Freq freq) {
        long total = 0
        Freq cf = new Freq()
        for (int i = 0; i < 256; ++i) {
            char c = i
            Long v = freq.get(c)
            if (null != v) {
                cf.put(c, total)
                total += v
            }
        }
        return cf
    }

    private static Triple<BigInteger, Integer, Freq> arithmeticCoding(String str, Long radix) {
        // Convert the string into a char array
        char[] chars = str.toCharArray()

        // The frequency characters
        Freq freq = new Freq()
        for (char c : chars) {
            if (freq.containsKey(c)) {
                freq.put(c, freq[c] + 1)
            } else {
                freq.put(c, 1)
            }
        }

        // The cumulative frequency
        Freq cf = cumulativeFreq(freq)

        // Base
        BigInteger base = chars.length

        // LowerBound
        BigInteger lower = BigInteger.ZERO

        // Product of all frequencies
        BigInteger pf = BigInteger.ONE

        // Each term is multiplied by the product of the
        // frequencies of all previously occurring symbols
        for (char c : chars) {
            BigInteger x = cf[c]
            lower = lower * base + x * pf
            pf = pf * freq[c]
        }

        // Upper bound
        BigInteger upper = lower + pf

        int powr = 0
        BigInteger bigRadix = radix

        while (true) {
            pf = pf.divide(bigRadix)
            if (BigInteger.ZERO == pf) {
                break
            }
            powr++
        }

        BigInteger diff = (upper - BigInteger.ONE).divide(bigRadix.pow(powr))
        return new Triple<BigInteger, Integer, Freq>(diff, powr, freq)
    }

    private static String arithmeticDecoding(BigInteger num, long radix, int pwr, Freq freq) {
        BigInteger powr = radix
        BigInteger enc = num * powr.pow(pwr)
        long base = 0
        for (Long v : freq.values()) base += v

        // Create the cumulative frequency table
        Freq cf = cumulativeFreq(freq)

        // Create the dictionary
        Map<Long, Character> dict = new HashMap<>()
        for (Map.Entry<Character, Long> entry : cf.entrySet()) dict[entry.value] = entry.key

        // Fill the gaps in the dictionary
        long lchar = -1
        for (long i = 0; i < base; ++i) {
            Character v = dict[i]
            if (null != v) {
                lchar = v
            } else if (lchar != -1) {
                dict[i] = lchar as Character
            }
        }

        // Decode the input number
        StringBuilder decoded = new StringBuilder((int) base)
        BigInteger bigBase = base
        for (long i = base - 1; i >= 0; --i) {
            BigInteger pow = bigBase.pow((int) i)
            BigInteger div = enc.divide(pow)
            Character c = dict[div.longValue()]
            BigInteger fv = freq[c]
            BigInteger cv = cf[c]
            BigInteger diff = enc - pow * cv
            enc = diff.divide(fv)
            decoded.append(c)
        }
        // Return the decoded output
        return decoded.toString()
    }

    static void main(String[] args) {
        long radix = 10
        String[] strings = ["DABDDB", "DABDDBBDDBA", "ABRACADABRA", "TOBEORNOTTOBEORTOBEORNOT"]
        String fmt = "%-25s=> %19s * %d^%s\n"
        for (String str : strings) {
            Triple<BigInteger, Integer, Freq> encoded = arithmeticCoding(str, radix)
            String dec = arithmeticDecoding(encoded.a, radix, encoded.b, encoded.c)
            System.out.printf(fmt, str, encoded.a, radix, encoded.b)
            if (!Objects.equals(str, dec)) throw new RuntimeException("\tHowever that is incorrect!")
        }
    }
}
