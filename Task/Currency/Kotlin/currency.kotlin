// version 1.1.2

import java.math.BigDecimal
import java.math.MathContext

fun main(args: Array<String>) {
    val mc = MathContext.DECIMAL128
    val nHamburger  = BigDecimal("4000000000000000", mc)
    val pHamburger  = BigDecimal("5.50")
    val nMilkshakes = BigDecimal("2", mc)
    val pMilkshakes = BigDecimal("2.86")
    val taxRate     = BigDecimal("0.0765")
    val price = nHamburger * pHamburger + nMilkshakes * pMilkshakes
    val tax = price * taxRate
    val fmt = "%20.2f"
    println("Total price before tax : ${fmt.format(price)}")
    println("Tax thereon @ 7.65%    : ${fmt.format(tax)}")
    println("Total price after tax  : ${fmt.format(price + tax)}")
}
