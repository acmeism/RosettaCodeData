// version 1.1.3

val fStrs = listOf("MAC" to "MCC", "KN" to "N", "K" to "C", "PH" to "FF",
                   "PF" to "FF", "SCH" to "SSS")

val lStrs = listOf("EE" to "Y", "IE" to "Y", "DT" to "D", "RT" to "D",
                   "RD" to "D", "NT" to "D", "ND" to "D")

val mStrs = listOf("EV" to "AF", "KN" to "N", "SCH" to "SSS", "PH" to "FF")

val eStrs = listOf("JR", "JNR", "SR", "SNR")

fun Char.isVowel() = this in "AEIOU"

fun String.isRoman() = this.all { it in "IVX" }

fun nysiis(word: String): String {
    if (word.isEmpty()) return word
    var w = word.toUpperCase()
    val ww = w.split(' ', ',')
    if (ww.size > 1 && ww.last().isRoman()) w = w.dropLast(ww.last().length)
    for (c in " ,'-") w = w.replace(c.toString(), "")
    for (eStr in eStrs)
        if (w.endsWith(eStr)) w = w.dropLast(eStr.length)

    for (fStr in fStrs)
        if (w.startsWith(fStr.first)) w = w.replaceFirst(fStr.first, fStr.second)

    for (lStr in lStrs)
        if (w.endsWith(lStr.first)) w = w.dropLast(2) + lStr.second

    val key = StringBuilder().append(w[0])
    w = w.drop(1)
    for (mStr in mStrs) w = w.replace(mStr.first, mStr.second)
    val sb = StringBuilder().append(key[0]).append(w)
    var i = 1
    var len = sb.length
    while (i < len) {
        when (sb[i]) {
            in "EIOU" -> sb[i] = 'A'
            'Q'       -> sb[i] = 'G'
            'Z'       -> sb[i] = 'S'
            'M'       -> sb[i] = 'N'
            'K'       -> sb[i] = 'C'
            'H'       -> if (!sb[i - 1].isVowel() || (i < len - 1 && !sb[i + 1].isVowel())) sb[i] = sb[i - 1]
            'W'       -> if (sb[i - 1].isVowel()) sb[i] = 'A'
        }
        if (sb[i] != sb[i - 1]) {
            i++
        }
        else {
            sb.deleteCharAt(i)  // deprecated method - should use deleteAt in later Kotlin versions
            len--
        }
    }
    if (sb[len - 1] == 'S') {
        sb.setLength(len - 1)
        len--
    }
    if (len > 1 && sb.substring(len - 2) == "AY") {
        sb.setLength(len - 2)
        sb.append("Y")
        len--
    }
    if (len > 0 && sb[len - 1] == 'A') {
        sb.setLength(len - 1)
        len--
    }
    var prev = key[0]
    for (j in 1 until len) {
        val c = sb[j]
        if (prev != c) {
           key.append(c)
           prev = c
        }
    }
    return key.toString()
}

fun main(args:Array<String>) {
    val names = listOf(
        "Bishop", "Carlson", "Carr", "Chapman",
        "Franklin", "Greene", "Harper", "Jacobs", "Larson", "Lawrence",
        "Lawson", "Louis, XVI", "Lynch", "Mackenzie", "Matthews", "May jnr",
        "McCormack", "McDaniel", "McDonald", "Mclaughlin", "Morrison",
        "O'Banion", "O'Brien", "Richards", "Silva", "Watkins", "Xi",
        "Wheeler", "Willis", "brown, sr", "browne, III", "browne, IV",
        "knight", "mitchell", "o'daniel", "bevan", "evans", "D'Souza",
        "Hoyle-Johnson", "Vaughan Williams", "de Sousa", "de la Mare II"
    )
    for (name in names) {
        var name2 = nysiis(name)
        if (name2.length > 6) name2 = "${name2.take(6)}(${name2.drop(6)})"
        println("${name.padEnd(16)} : $name2")
    }
}
