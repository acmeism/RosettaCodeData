package main

import (
    "fmt"
    "strings"
)

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

var freq = [26]float64{
    0.08167, 0.01492, 0.02782, 0.04253, 0.12702, 0.02228, 0.02015,
    0.06094, 0.06966, 0.00153, 0.00772, 0.04025, 0.02406, 0.06749,
    0.07507, 0.01929, 0.00095, 0.05987, 0.06327, 0.09056, 0.02758,
    0.00978, 0.02360, 0.00150, 0.01974, 0.00074,
}

func sum(a []float64) (sum float64) {
    for _, f := range a {
        sum += f
    }
    return
}

func bestMatch(a []float64) int {
    sum := sum(a)
    bestFit, bestRotate := 1e100, 0
    for rotate := 0; rotate < 26; rotate++ {
        fit := 0.0
        for i := 0; i < 26; i++ {
            d := a[(i+rotate)%26]/sum - freq[i]
            fit += d * d / freq[i]
        }
        if fit < bestFit {
            bestFit, bestRotate = fit, rotate
        }
    }
    return bestRotate
}

func freqEveryNth(msg []int, key []byte) float64 {
    l := len(msg)
    interval := len(key)
    out := make([]float64, 26)
    accu := make([]float64, 26)
    for j := 0; j < interval; j++ {
        for k := 0; k < 26; k++ {
            out[k] = 0.0
        }
        for i := j; i < l; i += interval {
            out[msg[i]]++
        }
        rot := bestMatch(out)
        key[j] = byte(rot + 65)
        for i := 0; i < 26; i++ {
            accu[i] += out[(i+rot)%26]
        }
    }
    sum := sum(accu)
    ret := 0.0
    for i := 0; i < 26; i++ {
        d := accu[i]/sum - freq[i]
        ret += d * d / freq[i]
    }
    return ret
}

func decrypt(text, key string) string {
    var sb strings.Builder
    ki := 0
    for _, c := range text {
        if c < 'A' || c > 'Z' {
            continue
        }
        ci := (c - rune(key[ki]) + 26) % 26
        sb.WriteRune(ci + 65)
        ki = (ki + 1) % len(key)
    }
    return sb.String()
}

func main() {
    enc := strings.Replace(encoded, " ", "", -1)
    txt := make([]int, len(enc))
    for i := 0; i < len(txt); i++ {
        txt[i] = int(enc[i] - 'A')
    }
    bestFit, bestKey := 1e100, ""
    fmt.Println("  Fit     Length   Key")
    for j := 1; j <= 26; j++ {
        key := make([]byte, j)
        fit := freqEveryNth(txt, key)
        sKey := string(key)
        fmt.Printf("%f    %2d     %s", fit, j, sKey)
        if fit < bestFit {
            bestFit, bestKey = fit, sKey
            fmt.Print(" <--- best so far")
        }
        fmt.Println()
    }
    fmt.Println("\nBest key :", bestKey)
    fmt.Printf("\nDecrypted text:\n%s\n", decrypt(enc, bestKey))
}
