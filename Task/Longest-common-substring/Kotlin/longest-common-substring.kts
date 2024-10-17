// version 1.1.2

fun lcs(a: String, b: String): String {
    if (a.length > b.length) return lcs(b, a)
    var res = ""
    for (ai in 0 until a.length) {
        for (len in a.length - ai downTo 1) {
            for (bi in 0 until b.length - len) {
                if (a.regionMatches(ai, b, bi,len) && len > res.length) {
                    res = a.substring(ai, ai + len)
                }
            }
        }
    }
    return res
}

fun main(args: Array<String>) = println(lcs("testing123testing", "thisisatest"))
