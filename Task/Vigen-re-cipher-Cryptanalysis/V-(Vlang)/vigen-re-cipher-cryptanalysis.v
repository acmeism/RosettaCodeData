import strings
const encoded =
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

const freq = [
    0.08167, 0.01492, 0.02782, 0.04253, 0.12702, 0.02228, 0.02015,
    0.06094, 0.06966, 0.00153, 0.00772, 0.04025, 0.02406, 0.06749,
    0.07507, 0.01929, 0.00095, 0.05987, 0.06327, 0.09056, 0.02758,
    0.00978, 0.02360, 0.00150, 0.01974, 0.00074,
]

fn sum(a []f64) f64 {
    mut s := 0.0
    for f in a {
        s += f
    }
    return s
}

fn best_match(a []f64) int {
    s := sum(a)
    mut best_fit, mut best_rotate := 1e100, 0
    for rotate in 0..26 {
        mut fit := 0.0
        for i in 0..26 {
            d := a[(i+rotate)%26]/s - freq[i]
            fit += d * d / freq[i]
        }
        if fit < best_fit {
            best_fit, best_rotate = fit, rotate
        }
    }
    return best_rotate
}

fn freq_every_nth(msg []int, mut key []u8) f64 {
    l := msg.len
    interval := key.len
    mut out := []f64{len: 26}
    mut accu := []f64{len: 26}
    for j in 0..interval {
        for z in 0..26 {
            out[z] = 0.0
        }
        for i := j; i < l; i += interval {
            out[msg[i]]++
        }
        rot := best_match(out)
        key[j] = u8(rot + 65)
        for i := 0; i < 26; i++ {
            accu[i] += out[(i+rot)%26]
        }
    }
    s := sum(accu)
    mut ret := 0.0
    for i := 0; i < 26; i++ {
        d := accu[i]/s - freq[i]
        ret += d * d / freq[i]
    }
    return ret
}

fn decrypt(text string, key string) string {
    mut sb := strings.new_builder(128)
    mut ki := 0
    for c in text {
        if c < 'A'[0] || c > 'Z'[0] {
            continue
        }
        ci := (c - key[ki] + 26) % 26
        sb.write_rune(ci + 65)
        ki = (ki + 1) % key.len
    }
    return sb.str()
}

fn main() {
    enc := encoded.replace(" ", "")
    mut txt := []int{len: enc.len}
    for i in 0..txt.len {
        txt[i] = int(enc[i] - 'A'[0])
    }
    mut best_fit, mut best_key := 1e100, ""
    println("  Fit     Length   Key")
    for j := 1; j <= 26; j++ {
        mut key := []u8{len: j}
        fit := freq_every_nth(txt, mut key)
        s_key := key.bytestr()
        print("${fit:.6}    ${j:2}     $s_key")
        if fit < best_fit {
            best_fit, best_key = fit, s_key
            print(" <--- best so far")
        }
        println('')
    }
    println("\nBest key : $best_key")
    println("\nDecrypted text:\n${decrypt(enc, best_key)}")
}
