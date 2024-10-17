// version 1.0.6

import java.math.BigInteger

object IBAN {
    /* List updated to release 73, January 2017, of IBAN Registry (75 countries) */
    private const val countryCodes = "" +
            "AD24 AE23 AL28 AT20 AZ28 BA20 BE16 BG22 BH22 BR29 " +
            "BY28 CH21 CR22 CY28 CZ24 DE22 DK18 DO28 EE20 ES24 " +
            "FI18 FO18 FR27 GB22 GE22 GI23 GL18 GR27 GT28 HR21 " +
            "HU28 IE22 IL23 IQ23 IS26 IT27 JO30 KW30 KZ20 LB28 " +
            "LC32 LI21 LT20 LU20 LV21 MC27 MD24 ME22 MK19 MR27 " +
            "MT31 MU30 NL18 NO15 PK24 PL28 PS29 PT25 QA29 RO24 " +
            "RS22 SA24 SC31 SE24 SI19 SK24 SM27 ST25 SV28 TL23 " +
            "TN24 TR26 UA29 VG24 XK20"

    fun isValid(iban: String): Boolean {
        // remove spaces from IBAN
        var s = iban.replace(" ", "")

        // check country code and length
        s.substring(0, 2) + s.length in countryCodes || return false

        // move first 4 characters to the end
        s = s.substring(4) + s.substring(0, 4)

        // replace A to Z with numbers 10 To 35
        s = s.replace(Regex("[A-Z]")) { (10 + (it.value[0] - 'A')).toString() }

        // check whether mod 97 calculation gives a remainder of 1
        return BigInteger(s) % BigInteger.valueOf(97L) == BigInteger.ONE
    }
}

fun main() {
    val ibans = arrayOf(
            "GB82 WEST 1234 5698 7654 32",
            "GB82 TEST 1234 5698 7654 32"
    )
    for (iban in ibans) {
        val valid = IBAN.isValid(iban)
        println(iban + if (valid) " may be valid" else " is not valid")
    }
}
