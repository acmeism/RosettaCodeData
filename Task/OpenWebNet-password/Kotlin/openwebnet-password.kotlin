// version 1.1.51

fun ownCalcPass(password: Long, nonce: String): Long {
    val m1        = 0xFFFF_FFFFL
    val m8        = 0xFFFF_FFF8L
    val m16       = 0xFFFF_FFF0L
    val m128      = 0xFFFF_FF80L
    val m16777216 = 0xFF00_0000L

    var flag = true
    var num1 = 0L
    var num2 = 0L

    for (c in nonce) {
        num2 = num2 and m1

        when (c) {
            '1' -> {
                if (flag) num2 = password
                flag = false
                num1 = num2 and m128
                num1 = num1 ushr 7
                num2 = num2 shl 25
                num1 = num1 + num2
            }

            '2' -> {
                if (flag) num2 = password
                flag = false
                num1 = num2 and m16
                num1 = num1 ushr 4
                num2 = num2 shl 28
                num1 = num1 + num2
            }

            '3' -> {
                if (flag) num2 = password
                flag = false
                num1 = num2 and m8
                num1 = num1 ushr 3
                num2 = num2 shl 29
                num1 = num1 + num2
            }

            '4' -> {
                if (flag) num2 = password
                flag = false
                num1 = num2 shl 1
                num2 = num2 ushr 31
                num1 = num1 + num2
            }

            '5' -> {
                if (flag) num2 = password
                flag = false
                num1 = num2 shl 5
                num2 = num2 ushr 27
                num1 = num1 + num2
            }

            '6' -> {
                if (flag) num2 = password
                flag = false
                num1 = num2 shl 12
                num2 = num2 ushr 20
                num1 = num1 + num2
            }

            '7' -> {
                if (flag) num2 = password
                flag = false
                num1 = num2 and 0xFF00L
                num1 = num1 + ((num2 and 0xFFL) shl 24)
                num1 = num1 + ((num2 and 0xFF0000L) ushr 16)
                num2 = (num2 and m16777216) ushr 8
                num1 = num1 + num2
            }

            '8' -> {
                if (flag) num2 = password
                flag = false
                num1 = num2 and 0xFFFFL
                num1 = num1 shl 16
                num1 = num1 + (num2 ushr 24)
                num2 = num2 and 0xFF0000L
                num2 = num2 ushr 8
                num1 = num1 + num2
            }

            '9' -> {
                if (flag) num2 = password
                flag = false
                num1 = num2.inv()
            }

            else -> num1 = num2
        }
        num2 = num1
    }
    return num1 and m1
}

fun ownTestCalcPass(passwd: String, nonce: String, expected: Long) {
    val res = ownCalcPass(passwd.toLong(), nonce)
    val m = "$passwd  $nonce  $res  $expected"
    println(if (res == expected) "PASS  $m" else "FAIL  $m")
}

fun main(args: Array<String>) {
    ownTestCalcPass("12345", "603356072", 25280520)
    ownTestCalcPass("12345", "410501656", 119537670)
}
