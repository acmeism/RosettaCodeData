# ciphertext block {{{1
const ciphertext = filter(isalpha, """
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
""")
# }}}

# character frequencies {{{1
const letters = Dict{Char, Float32}(
    'E' => 12.702,
    'T' => 9.056,
    'A' => 8.167,
    'O' => 7.507,
    'I' => 6.966,
    'N' => 6.749,
    'S' => 6.327,
    'H' => 6.094,
    'R' => 5.987,
    'D' => 4.253,
    'L' => 4.025,
    'C' => 2.782,
    'U' => 2.758,
    'M' => 2.406,
    'W' => 2.361,
    'F' => 2.228,
    'G' => 2.015,
    'Y' => 1.974,
    'P' => 1.929,
    'B' => 1.492,
    'V' => 0.978,
    'K' => 0.772,
    'J' => 0.153,
    'X' => 0.150,
    'Q' => 0.095,
    'Z' => 0.074)
const digraphs = Dict{AbstractString, Float32}(
    "TH" => 15.2,
    "HE" => 12.8,
    "IN" => 9.4,
    "ER" => 9.4,
    "AN" => 8.2,
    "RE" => 6.8,
    "ND" => 6.3,
    "AT" => 5.9,
    "ON" => 5.7,
    "NT" => 5.6,
    "HA" => 5.6,
    "ES" => 5.6,
    "ST" => 5.5,
    "EN" => 5.5,
    "ED" => 5.3,
    "TO" => 5.2,
    "IT" => 5.0,
    "OU" => 5.0,
    "EA" => 4.7,
    "HI" => 4.6,
    "IS" => 4.6,
    "OR" => 4.3,
    "TI" => 3.4,
    "AS" => 3.3,
    "TE" => 2.7,
    "ET" => 1.9,
    "NG" => 1.8,
    "OF" => 1.6,
    "AL" => 0.9,
    "DE" => 0.9,
    "SE" => 0.8,
    "LE" => 0.8,
    "SA" => 0.6,
    "SI" => 0.5,
    "AR" => 0.4,
    "VE" => 0.4,
    "RA" => 0.4,
    "LD" => 0.2,
    "UR" => 0.2)
const trigraphs = Dict{AbstractString, Float32}(
    "THE" => 18.1,
    "AND" => 7.3,
    "ING" => 7.2,
    "ION" => 4.2,
    "ENT" => 4.2,
    "HER" => 3.6,
    "FOR" => 3.4,
    "THA" => 3.3,
    "NTH" => 3.3,
    "INT" => 3.2,
    "TIO" => 3.1,
    "ERE" => 3.1,
    "TER" => 3.0,
    "EST" => 2.8,
    "ERS" => 2.8,
    "HAT" => 2.6,
    "ATI" => 2.6,
    "ATE" => 2.5,
    "ALL" => 2.5,
    "VER" => 2.4,
    "HIS" => 2.4,
    "HES" => 2.4,
    "ETH" => 2.4,
    "OFT" => 2.2,
    "STH" => 2.1,
    "RES" => 2.1,
    "OTH" => 2.1,
    "ITH" => 2.1,
    "FTH" => 2.1,
    "ONT" => 2.0)
# 1}}}

function decrypt(enc::ASCIIString, key::ASCIIString)
    const enclen = length(enc)
    const keylen = length(key)

    if keylen < enclen
        key = (key^(div(enclen - keylen, keylen) + 2))[1:enclen]
    end

    msg = Array(Char, enclen)

    for i=1:enclen
        msg[i] = Char((Int(enc[i]) - Int(key[i]) + 26) % 26 + 65)
    end

    msg::Array{Char, 1}
end

function cryptanalyze(enc::ASCIIString; maxkeylen::Integer = 20)
    const enclen = length(enc)
    maxkey = ""
    maxdec = ""
    maxscore = 0.0

    for keylen=1:maxkeylen
        key = Array(Char, keylen)
        idx = filter(x -> x % keylen == 0, 1:enclen) - keylen + 1

        for i=1:keylen
            maxsubscore = 0.0

            for j='A':'Z'
                subscore = 0.0

                for k in decrypt(enc[idx], ascii(string(j)))
                    subscore += get(letters, k, 0.0)
                end

                if subscore > maxsubscore
                    maxsubscore = subscore
                    key[i] = j
                end
            end

            idx += 1
        end

        key = join(key)
        const dec = decrypt(enc, key)
        score = 0.0

        for i in dec
            score += get(letters, i, 0.0)
        end

        for i=1:enclen - 2
            const digraph = string(dec[i], dec[i + 1])
            const trigraph = string(dec[i], dec[i + 1], dec[i + 2])

            if haskey(digraphs, digraph)
                score += 2 * get(digraphs, digraph, 0.0)
            end

            if haskey(trigraphs, trigraph)
                score += 3 * get(trigraphs, trigraph, 0.0)
            end
        end

        if score > maxscore
            maxscore = score
            maxkey = key
            maxdec = dec
        end
    end

    (maxkey, join(maxdec))::Tuple{ASCIIString, ASCIIString}
end

key, dec = cryptanalyze(ciphertext)
println("key: ", key, "\n\n", dec)

# post-compilation profiling run
gc()
t = @elapsed cryptanalyze(ciphertext)
println("\nelapsed time: ", t, " seconds")
