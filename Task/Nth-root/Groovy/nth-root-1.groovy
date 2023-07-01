import static Constants.tolerance
import static java.math.RoundingMode.HALF_UP

def root(double base, double n) {
    double xOld = 1
    double xNew = 0
    while (true) {
        xNew = ((n - 1) * xOld + base/(xOld)**(n - 1))/n
    if ((xNew - xOld).abs() < tolerance) { break }
        xOld = xNew
    }
    (xNew as BigDecimal).setScale(7, HALF_UP)
}
