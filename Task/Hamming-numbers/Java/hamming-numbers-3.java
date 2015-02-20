import java.math.BigInteger;

public class Hamming
{
    public static void main(String args[])
    {
        Stream hamming = makeHamming();
        System.out.print("H[1..20] ");
        for (int i=0; i<20; i++) {
            System.out.print(hamming.value());
            System.out.print(" ");
            hamming = hamming.advance();
        }
        System.out.println();

        System.out.print("H[1691] ");
        hamming = makeHamming();
        for (int i=1; i<1691; i++) {
            hamming = hamming.advance();
        }
        System.out.println(hamming.value());

        hamming = makeHamming();
        System.out.print("H[10^6] ");
        for (int i=1; i<1000000; i++) {
            hamming = hamming.advance();
        }
        System.out.println(hamming.value());
    }

    public interface Stream
    {
        BigInteger value();
        Stream advance();
    }

    public static class MultStream implements Stream
    {
        MultStream(int mult)
        { m_mult = BigInteger.valueOf(mult); }
        MultStream setBase(Stream s)
        { m_base = s; return this; }
        public BigInteger value()
        { return m_mult.multiply(m_base.value()); }
        public Stream advance()
        { return setBase(m_base.advance()); }

        private final BigInteger m_mult;
        private Stream m_base;
    }

    private final static class RegularStream implements Stream
    {
        RegularStream(Stream[] streams, BigInteger val)
        {
            m_streams = streams;
            m_val = val;
        }
        public BigInteger value()
        { return m_val; }

        public Stream advance()
        {
            // memoized value for the next stream instance.
            if (m_advance != null) { return m_advance; }

            int minidx = 0 ;
            BigInteger next = nextStreamValue(0);
            for (int i=1; i<m_streams.length; i++) {
                BigInteger v = nextStreamValue(i);
                if (v.compareTo(next) < 0) {
                    next = v;
                    minidx = i;
                }
            }
            RegularStream ret = new RegularStream(m_streams, next);
            // memoize the value!
            m_advance = ret;
            m_streams[minidx].advance();
            return ret;
        }
        private BigInteger nextStreamValue(int streamidx)
        {
            // skip past duplicates in the streams we're merging.
            BigInteger ret = m_streams[streamidx].value();
            while (ret.equals(m_val)) {
                m_streams[streamidx] = m_streams[streamidx].advance();
                ret = m_streams[streamidx].value();
            }
            return ret;
        }
        private final Stream[] m_streams;
        private final BigInteger m_val;
        private RegularStream m_advance = null;
    }

    private final static Stream makeHamming()
    {
        MultStream nums[] = new MultStream[] {
            new MultStream(2),
            new MultStream(3),
            new MultStream(5)
        };
        Stream ret = new RegularStream(nums, BigInteger.ONE);
        for (int i=0; i<nums.length; i++) {
            nums[i].setBase(ret);
        }
        return ret;
    }
}
