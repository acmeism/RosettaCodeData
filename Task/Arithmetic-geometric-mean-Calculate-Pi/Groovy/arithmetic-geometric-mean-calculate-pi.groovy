import java.math.MathContext

class CalculatePi {
    private static final MathContext con1024 = new MathContext(1024)
    private static final BigDecimal bigTwo = new BigDecimal(2)
    private static final BigDecimal bigFour = new BigDecimal(4)

    private static BigDecimal bigSqrt(BigDecimal bd, MathContext con) {
        BigDecimal x0 = BigDecimal.ZERO
        BigDecimal x1 = BigDecimal.valueOf(Math.sqrt(bd.doubleValue()))
        while (!Objects.equals(x0, x1)) {
            x0 = x1
            x1 = (bd.divide(x0, con) + x0).divide(bigTwo, con)
        }
        return x1
    }

    static void main(String[] args) {
        BigDecimal a = BigDecimal.ONE
        BigDecimal g = a.divide(bigSqrt(bigTwo, con1024), con1024)
        BigDecimal t
        BigDecimal sum = BigDecimal.ZERO
        BigDecimal pow = bigTwo
        while (!Objects.equals(a, g)) {
            t = (a + g).divide(bigTwo, con1024)
            g = bigSqrt(a * g, con1024)
            a = t
            pow = pow * bigTwo
            sum = sum + (a * a - g * g) * pow
        }
        BigDecimal pi = (bigFour * (a * a)).divide(BigDecimal.ONE - sum, con1024)
        System.out.println(pi)
    }
}
