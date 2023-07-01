// version 1.1.3

val encoded =
    "MOMUD EKAPV TQEFM OEVHP AJMII CDCTI FGYAG JSPXY ALUYM NSMYH" +
    "VUXJE LEPXJ FXGCM JHKDZ RYICU HYPUS PGIGM OIYHF WHTCQ KMLRD" +
    "ITLXZ LJFVQ GHOLW CUHLO MDSOE KTALU VYLNZ RFGBX PHVGA LWQIS" +
    "FGRPH JOOFW GUBYI LAPLA LCAFA AMKLG CETDW VOELJ IKGJB XPHVG" +
    "ALWQC SNWBU BYHCU HKOCE XJEYK BQKVY KIIEH GRLGH XEOLW AWFOJ" +
    "ILOVV RHPKD WIHKN ATUHN VRYAQ DIVHX FHRZV QWMWV LGSHN NLVZS" +
    "JLAKI FHXUF XJLXM TBLQV RXXHR FZXGV LRAJI EXPRV OSMNP KEPDT" +
    "LPRWM JAZPK LQUZA ALGZX GVLKL GJTUI ITDSU REZXJ ERXZS HMPST" +
    "MTEOE PAPJH SMFNB YVQUZ AALGA YDNMP AQOWT UHDBV TSMUE UIMVH" +
    "QGVRW AEFSP EMPVE PKXZY WLKJA GWALT VYYOB YIXOK IHPDS EVLEV" +
    "RVSGB JOGYW FHKBL GLXYA MVKIS KIEHY IMAPX UOISK PVAGN MZHPW" +
    "TTZPV XFCCD TUHJH WLAPF YULTB UXJLN SIJVV YOVDJ SOLXG TGRVO" +
    "SFRII CTMKO JFCQF KTINQ BWVHG TENLH HOGCS PSFPV GJOKM SIFPR" +
    "ZPAAS ATPTZ FTPPD PORRF TAXZP KALQA WMIUD BWNCT LEFKO ZQDLX" +
    "BUXJL ASIMR PNMBF ZCYLV WAPVF QRHZV ZGZEF KBYIO OFXYE VOWGB" +
    "BXVCB XBAWG LQKCM ICRRX MACUO IKHQU AJEGL OIJHH XPVZW JEWBA" +
    "FWAML ZZRXJ EKAHV FASMU LVVUT TGK"

val freq = doubleArrayOf(
    0.08167, 0.01492, 0.02782, 0.04253, 0.12702, 0.02228, 0.02015,
    0.06094, 0.06966, 0.00153, 0.00772, 0.04025, 0.02406, 0.06749,
    0.07507, 0.01929, 0.00095, 0.05987, 0.06327, 0.09056, 0.02758,
    0.00978, 0.02360, 0.00150, 0.01974, 0.00074
)

fun bestMatch(a: DoubleArray): Int {
    val sum = a.sum()
    var bestFit = 1e100
    var bestRotate = 0
    for (rotate in 0..25) {
        var fit = 0.0
        for (i in 0..25) {
            val d = a[(i + rotate) % 26] / sum - freq[i]
            fit += d * d / freq[i]
        }
        if (fit < bestFit) {
            bestFit = fit
            bestRotate = rotate
        }
    }
    return bestRotate
}

fun freqEveryNth(msg: IntArray, key: CharArray): Double {
    val len = msg.size
    val interval = key.size
    val out = DoubleArray(26)
    val accu = DoubleArray(26)
    for (j in 0 until interval) {
        out.fill(0.0)
        for (i in j until len step interval) out[msg[i]]++
        val rot = bestMatch(out)
        key[j] = (rot + 65).toChar()
        for (i in 0..25) accu[i] += out[(i + rot) % 26]
    }
    val sum = accu.sum()
    var ret = 0.0
    for (i in 0..25) {
        val d = accu[i] / sum - freq[i]
        ret += d * d / freq[i]
    }
    return ret
}

fun decrypt(text: String, key: String): String {
    val sb = StringBuilder()
    var ki = 0
    for (c in text) {
        if (c !in 'A'..'Z') continue
        val ci = (c.toInt() - key[ki].toInt() +  26) % 26
        sb.append((ci + 65).toChar())
        ki = (ki + 1) % key.length
    }
    return sb.toString()
}

fun main(args: Array<String>) {
    val enc = encoded.replace(" ", "")
    val txt = IntArray(enc.length) { enc[it] - 'A' }
    var bestFit = 1e100
    var bestKey = ""
    val f = "%f    %2d     %s"
    println("  Fit     Length   Key")
    for (j in 1..26) {
        val key = CharArray(j)
        val fit = freqEveryNth(txt, key)
        val sKey = key.joinToString("")
        print(f.format(fit, j, sKey))
        if (fit < bestFit) {
           bestFit = fit
           bestKey = sKey
           print(" <--- best so far")
        }
        println()
    }
    println()
    println("Best key : $bestKey")
    println("\nDecrypted text:\n${decrypt(enc, bestKey)}")
}
