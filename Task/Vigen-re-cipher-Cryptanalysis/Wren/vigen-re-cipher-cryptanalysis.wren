import "/math" for Nums
import "/iterate" for Stepped
import "/str" for Char, Str
import "/fmt" for Fmt

var encoded =
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

var freq = [
    0.08167, 0.01492, 0.02782, 0.04253, 0.12702, 0.02228, 0.02015,
    0.06094, 0.06966, 0.00153, 0.00772, 0.04025, 0.02406, 0.06749,
    0.07507, 0.01929, 0.00095, 0.05987, 0.06327, 0.09056, 0.02758,
    0.00978, 0.02360, 0.00150, 0.01974, 0.00074
]

var bestMatch = Fn.new { |a|
    var sum = Nums.sum(a)
    var bestFit = 1e100
    var bestRotate = 0
    for (rotate in 0..25) {
        var fit = 0
        for (i in 0..25) {
            var d = a[(i + rotate) % 26] / sum - freq[i]
                fit = fit + d * d / freq[i]
        }
        if (fit < bestFit) {
            bestFit = fit
            bestRotate = rotate
        }
    }
    return bestRotate
}

var freqEveryNth = Fn.new { |msg, key|
    var len = msg.count
    var interval = key.count
    var out = List.filled(26, 0)
    var accu = List.filled(26, 0)
    for (j in 0...interval) {
        for (i in 0..25) out[i] = 0
        for (i in Stepped.new(j...len, interval)) out[msg[i]] = out[msg[i]] + 1
        var rot = bestMatch.call(out)
        key[j] = Char.fromCode(rot + 65)
        for (i in 0..25) accu[i] = accu[i] + out[(i + rot) % 26]
    }
    var sum = Nums.sum(accu)
    var ret = 0
    for (i in 0..25) {
        var d = accu[i] / sum - freq[i]
        ret = ret + d * d / freq[i]
    }
    return ret
}

var decrypt = Fn.new { |text, key|
    var sb = ""
    var ki = 0
    for (c in text) {
        if (Char.isAsciiUpper(c)) {
            var ci = (c.bytes[0] - key[ki].bytes[0] +  26) % 26
            sb = sb + Char.fromCode(ci + 65)
            ki = (ki + 1) % key.count
        }
    }
    return sb
}

var enc = encoded.replace(" ", "")
var txt = List.filled(enc.count, 0)
for (i in 0...txt.count) txt[i] = Char.code(enc[i]) - 65
var bestFit = 1e100
var bestKey = ""
var f = "$f    $2d     $s"
System.print("  Fit     Length   Key")
for (j in 1..26) {
    var key = List.filled(j, "")
    var fit = freqEveryNth.call(txt, key)
    var sKey = key.join("")
    Fmt.write(f, fit, j, sKey)
    if (fit < bestFit) {
       bestFit = fit
       bestKey = sKey
       System.write(" <--- best so far")
    }
    System.print()
}
System.print()
System.print("Best key : %(bestKey)")
System.print("\nDecrypted text:\n%(decrypt.call(enc, bestKey))")
