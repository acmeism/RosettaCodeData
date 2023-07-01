const val digits = "0123456789"

fun deBruijn(k: Int, n: Int): String {
    val alphabet = digits.substring(0, k)
    val a = ByteArray(k * n)
    val seq = mutableListOf<Byte>()
    fun db(t: Int, p: Int) {
        if (t > n) {
            if (n % p == 0) {
                seq.addAll(a.sliceArray(1..p).asList())
            }
        } else {
            a[t] = a[t - p]
            db(t + 1, p)
            var j = a[t - p] + 1
            while (j < k) {
                a[t] = j.toByte()
                db(t + 1, t)
                j++
            }
        }
    }
    db(1, 1)
    val buf = StringBuilder()
    for (i in seq) {
        buf.append(alphabet[i.toInt()])
    }
    val b = buf.toString()
    return b + b.subSequence(0, n - 1)
}

fun allDigits(s: String): Boolean {
    for (c in s) {
        if (c < '0' || '9' < c) {
            return false
        }
    }
    return true
}

fun validate(db: String) {
    val le = db.length
    val found = MutableList(10_000) { 0 }
    val errs = mutableListOf<String>()
    // Check all strings of 4 consecutive digits within 'db'
    // to see if all 10,000 combinations occur without duplication.
    for (i in 0 until le - 3) {
        val s = db.substring(i, i + 4)
        if (allDigits(s)) {
            val n = s.toInt()
            found[n]++
        }
    }
    for (i in 0 until 10_000) {
        if (found[i] == 0) {
            errs.add("    PIN number %04d missing".format(i))
        } else if (found[i] > 1) {
            errs.add("    PIN number %04d occurs %d times".format(i, found[i]))
        }
    }
    val lerr = errs.size
    if (lerr == 0) {
        println("  No errors found")
    } else {
        val pl = if (lerr == 1) {
            ""
        } else {
            "s"
        }
        println("  $lerr error$pl found:")
        println(errs.joinToString("\n"))
    }
}

fun main() {
    var db = deBruijn(10, 4)
    val le = db.length

    println("The length of the de Bruijn sequence is $le")
    println("\nThe first 130 digits of the de Bruijn sequence are: ${db.subSequence(0, 130)}")
    println("\nThe last 130 digits of the de Bruijn sequence are: ${db.subSequence(le - 130, le)}")

    println("\nValidating the deBruijn sequence:")
    validate(db)

    println("\nValidating the reversed deBruijn sequence:")
    validate(db.reversed())

    val bytes = db.toCharArray()
    bytes[4443] = '.'
    db = String(bytes)
    println("\nValidating the overlaid deBruijn sequence:")
    validate(db)
}
