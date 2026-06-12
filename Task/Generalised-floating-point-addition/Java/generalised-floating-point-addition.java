import java.math.BigDecimal;

public class GeneralisedFloatingPointAddition {

    public static void main(String[] args) {
        BigDecimal oneExp72 = new BigDecimal("1E72");
        for ( int i = 0 ; i <= 21+7 ; i++ ) {
            String s = "12345679";
            for ( int j = 0 ; j < i ; j++ ) {
                s += "012345679";
            }
            int exp = 63 - 9*i;
            s += "E" + exp;
            BigDecimal num = new BigDecimal(s).multiply(BigDecimal.valueOf(81)).add(new BigDecimal("1E" + exp));
            System.out.printf("Test value (%s) equals computed value: %b.  Computed = %s%n", oneExp72, num.compareTo(oneExp72) == 0 , num);
        }
    }

}
