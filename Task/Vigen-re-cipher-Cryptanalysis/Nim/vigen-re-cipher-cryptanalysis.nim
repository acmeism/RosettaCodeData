import sequtils, strutils, sugar, tables, times

const

  CipherText = """MOMUD EKAPV TQEFM OEVHP AJMII CDCTI FGYAG JSPXY ALUYM NSMYH
                  VUXJE LEPXJ FXGCM JHKDZ RYICU HYPUS PGIGM OIYHF WHTCQ KMLRD
                  ITLXZ LJFVQ GHOLW CUHLO MDSOE KTALU VYLNZ RFGBX PHVGA LWQIS
                  FGRPH JOOFW GUBYI LAPLA LCAFA AMKLG CETDW VOELJ IKGJB XPHVG
                  ALWQC SNWBU BYHCU HKOCE XJEYK BQKVY KIIEH GRLGH XEOLW AWFOJ
                  ILOVV RHPKD WIHKN ATUHN VRYAQ DIVHX FHRZV QWMWV LGSHN NLVZS
                  JLAKI FHXUF XJLXM TBLQV RXXHR FZXGV LRAJI EXPRV OSMNP KEPDT
                  LPRWM JAZPK LQUZA ALGZX GVLKL GJTUI ITDSU REZXJ ERXZS HMPST
                  MTEOE PAPJH SMFNB YVQUZ AALGA YDNMP AQOWT UHDBV TSMUE UIMVH
                  QGVRW AEFSP EMPVE PKXZY WLKJA GWALT VYYOB YIXOK IHPDS EVLEV
                  RVSGB JOGYW FHKBL GLXYA MVKIS KIEHY IMAPX UOISK PVAGN MZHPW
                  TTZPV XFCCD TUHJH WLAPF YULTB UXJLN SIJVV YOVDJ SOLXG TGRVO
                  SFRII CTMKO JFCQF KTINQ BWVHG TENLH HOGCS PSFPV GJOKM SIFPR
                  ZPAAS ATPTZ FTPPD PORRF TAXZP KALQA WMIUD BWNCT LEFKO ZQDLX
                  BUXJL ASIMR PNMBF ZCYLV WAPVF QRHZV ZGZEF KBYIO OFXYE VOWGB
                  BXVCB XBAWG LQKCM ICRRX MACUO IKHQU AJEGL OIJHH XPVZW JEWBA
                  FWAML ZZRXJ EKAHV FASMU LVVUT TGK""".splitWhitespace.join()

  FreqLetters = {'E': 12.702, 'T': 9.056, 'A': 8.167, 'O': 7.507,
                 'I':  6.966, 'N': 6.749, 'S': 6.327, 'H': 6.094,
                 'R':  5.987, 'D': 4.253, 'L': 4.025, 'C': 2.782,
                 'U':  2.758, 'M': 2.406, 'W': 2.361, 'F': 2.228,
                 'G':  2.015, 'Y': 1.974, 'P': 1.929, 'B': 1.492,
                 'V':  0.978, 'K': 0.772, 'J': 0.153, 'X': 0.150,
                 'Q':  0.095, 'Z': 0.074}.toTable

  FreqDigraphs = {"TH": 15.2, "HE": 12.8, "IN": 9.4, "ER": 9.4,
                  "AN":  8.2, "RE":  6.8, "ND": 6.3, "AT": 5.9,
                  "ON":  5.7, "NT":  5.6, "HA": 5.6, "ES": 5.6,
                  "ST":  5.5, "EN":  5.5, "ED": 5.3, "TO": 5.2,
                  "IT":  5.0, "OU":  5.0, "EA": 4.7, "HI": 4.6,
                  "IS":  4.6, "OR":  4.3, "TI": 3.4, "AS": 3.3,
                  "TE":  2.7, "ET":  1.9, "NG": 1.8, "OF": 1.6,
                  "AL":  0.9, "DE":  0.9, "SE": 0.8, "LE": 0.8,
                  "SA":  0.6, "SI":  0.5, "AR": 0.4, "VE": 0.4,
                  "RA":  0.4, "LD":  0.2, "UR": 0.2}.toTable

  FreqTrigraphs = {"THE": 18.1, "AND": 7.3, "ING": 7.2, "ION": 4.2,
                   "ENT":  4.2, "HER": 3.6, "FOR": 3.4, "THA": 3.3,
                   "NTH":  3.3, "INT": 3.2, "TIO": 3.1, "ERE": 3.1,
                   "TER":  3.0, "EST": 2.8, "ERS": 2.8, "HAT": 2.6,
                   "ATI":  2.6, "ATE": 2.5, "ALL": 2.5, "VER": 2.4,
                   "HIS":  2.4, "HES": 2.4, "ETH": 2.4, "OFT": 2.2,
                   "STH":  2.1, "RES": 2.1, "OTH": 2.1, "ITH": 2.1,
                   "FTH":  2.1, "ONT": 2.0}.toTable

func decrypt(enc, key: string): string =
  let encLen = enc.len
  let keyLen = key.len
  result.setLen(encLen)
  var k = 0
  for i in 0..<encLen:
    result[i] = chr((ord(enc[i]) - ord(key[k]) + 26) mod 26 + ord('A'))
    k = (k + 1) mod keyLen

func cryptanalyze(enc: string; maxKeyLen = 20): tuple[maxKey, maxDec: string] =
  let encLen = enc.len
  var maxScore = 0.0

  for keyLen in 1..maxKeyLen:
    var key = newString(keyLen)
    var idx = collect(newSeq):
                for i in 1..encLen:
                  if i mod keyLen == 0:
                    i - keyLen

    for  i in 0..<keyLen:
      var maxSubscore = 0.0
      for j in 'A'..'Z':
        var subscore = 0.0
        let encidx = idx.mapIt(enc[it]).join()
        for k in decrypt(encidx, $j):
          subscore += FreqLetters[k]
        if subscore > maxSubscore:
          maxSubscore = subscore
          key[i] = j
      for item in idx.mitems: inc item

    let dec = decrypt(enc, key)
    var score = 0.0
    for i in dec:
      score += FreqLetters[i]

    for i in 0..(encLen - 3):
      let digraph = dec[i..(i+1)]
      let trigraph = dec[i..(i+2)]
      score += 2 * FreqDigraphs.getOrDefault(digraph)
      score += 3 * FreqTrigraphs.getOrDefault(trigraph)

    if score > maxScore:
      maxScore = score
      result.maxKey = key
      result.maxDec = dec

let t0 = cpuTime()
let (key, dec) = CipherText.cryptanalyze()
echo "key: ", key, '\n'
echo dec, '\n'
echo "Elapsed time: ", (cpuTime() - t0).formatFloat(ffDecimal, precision = 3), " s"
