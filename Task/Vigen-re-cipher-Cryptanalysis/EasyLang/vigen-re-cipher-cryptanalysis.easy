freq[] = [ 0.082 0.015 0.028 0.043 0.127 0.022 0.020 0.061 0.070 0.002 0.008 0.040 0.024 0.067 0.075 0.019 0.001 0.060 0.063 0.091 0.028 0.010 0.024 0.002 0.020 0.001 ]
#
func searchRot &a[] sum .
   bestFit = 1 / 0
   for rot = 0 to 25
      fit = 0
      for i = 1 to 26
         d = a[(i + rot) mod1 26] / sum - freq[i]
         fit += d * d / freq[i]
      .
      if fit < bestFit
         bestFit = fit
         bestRot = rot
      .
   .
   return bestRot
.
func bestKeyWithLen &msg[] lkey &key[] .
   lmsg = len msg[]
   len key[] lkey
   len out[] 26
   len accu[] 26
   for pos = 1 to lkey
      for i = 1 to 26 : out[i] = 0
      for i = pos step lkey to lmsg
         out[msg[i]] += 1
      .
      rot = searchRot out[] (lmsg div lkey)
      key[pos] = rot
      for i = 1 to 26
         accu[i] += out[(i + rot) mod1 26]
      .
   .
   for i = 1 to 26
      d = accu[i] / lmsg - freq[i]
      ret += d * d / freq[i]
   .
   return ret
.
func$ bytes2txt &b[] .
   for b in b[] : r$ &= strchar (b + 65)
   return r$
.
func$ decrypt &txt[] &key[] .
   ki = 1
   for c in txt[]
      ci = (c - key[ki]) mod 26
      res$ &= strchar (ci + 64)
      ki = (ki + 1) mod1 len key[]
   .
   return res$
.
repeat
   s$ = input
   until s$ = ""
   for c$ in strchars s$
      c = strcode c$
      if c >= 65 and c <= 90 : txt[] &= c - 64
   .
.
bestFit = 1 / 0
print "Fit   Key"
for klen = 1 to 20
   fit = bestKeyWithLen txt[] klen key[]
   x$ = ""
   if fit < bestFit
      bestFit = fit
      bestKey[] = key[]
      x$ = " <--- best so far"
   .
   print fit & "  " & bytes2txt key[] & x$
.
print ""
print "Best key: " & bytes2txt bestKey[]
print "Decrypted text:"
print decrypt txt[] bestKey[]
#
input_data
MOMUD EKAPV TQEFM OEVHP AJMII CDCTI FGYAG JSPXY ALUYM NSMYH
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
FWAML ZZRXJ EKAHV FASMU LVVUT TGK
