public class CompoundDuration {

    public static void main(String[] args) {
        compound(7259);
        compound(86400);
        compound(6000_000);
    }

    private static void compound(long seconds) {
        StringBuilder sb = new StringBuilder();

        seconds = addUnit(sb, seconds, 604800, " wk, ");
        seconds = addUnit(sb, seconds, 86400, " d, ");
        seconds = addUnit(sb, seconds, 3600, " hr, ");
        seconds = addUnit(sb, seconds, 60, " min, ");
        addUnit(sb, seconds, 1, " sec, ");

        sb.setLength(sb.length() > 2 ? sb.length() - 2 : 0);

        System.out.println(sb);
    }

    private static long addUnit(StringBuilder sb, long sec, long unit, String s) {
        long n;
        if ((n = sec / unit) > 0) {
            sb.append(n).append(s);
            sec %= (n * unit);
        }
        return sec;
    }
}
