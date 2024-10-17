// version 1.0.6

import java.math.BigInteger

fun main(args: Array<String>) {
    val a = BigInteger("2988348162058574136915891421498819466320163312926952423791023078876139")
    val b = BigInteger("2351399303373464486466122544523690094744975233415544072992656881240319")
    val m = BigInteger.TEN.pow(40)
    println(a.modPow(b, m))
}
