public class NivenNumberGaps {

    //  Title:  Increasing gaps between consecutive Niven numbers

    public static void main(String[] args) {
        long prevGap = 0;
        long prevN = 1;
        long index = 0;
        System.out.println("Gap      Gap Index   Starting Niven");
        for ( long n = 2 ; n < 20_000_000_000l ; n++ ) {
            if ( isNiven(n) ) {
                index++;
                long curGap = n - prevN;
                if ( curGap > prevGap ) {
                    System.out.printf("%3d  %,13d  %,15d%n", curGap, index, prevN);
                    prevGap = curGap;
                }
                prevN = n;
            }
        }
    }

    public static boolean isNiven(long n) {
        long sum = 0;
        long nSave = n;
        while ( n > 0 ) {
            sum += n % 10;
            n /= 10;
        }
        return nSave % sum == 0;
    }

}
