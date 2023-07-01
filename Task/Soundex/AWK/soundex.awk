#!/usr/bin/awk -f
BEGIN {
    subsep = ", "
    delete homs
}

/^[a-zA-Z]/ {
    sdx = strToSoundex($0)
    addHom(sdx, $0)
}

END {
    showHoms(3)
}

function strToSoundex(s,    sdx, i, ch, cd, lch) {
    if (length(s) == 0) return ""
    s = tolower(s)
    lch = substr(s, 1, 1);
    sdx = toupper(lch)
    lch = charToSoundex(lch)
    for (i = 2; i <= length(s); i++) {
        ch = substr(s, i, 1)
        cd = charToSoundex(ch)
        if (cd == 7) continue;
        if (cd && cd != lch) sdx = sdx cd
        lch = cd
    }
    sdx = substr(sdx "0000", 1, 4)
    return sdx
}

function charToSoundex(ch,   cd) {
    if      (ch ~ /[bfpv]/)     cd = 1
    else if (ch ~ /[cgjkqsxz]/) cd = 2
    else if (ch ~ /[dt]/)       cd = 3
    else if (ch == "l")         cd = 4
    else if (ch ~ /[mn]/)       cd = 5
    else if (ch == "r")         cd = 6
    else if (ch ~ /[hw]/)       cd = 7
    else                        cd = 0
    return cd;
}

function addHom(sdx, word) {
    if (!(homs[sdx])) homs[sdx] = ""
    homs[sdx] = homs[sdx] (homs[sdx] == "" ? "" : subsep) word
}

function showHoms(toShow,    i, n, wl, j) {
    for (i in homs) {
        printf i " "
        n = split(homs[i], wl, subsep)
        for (j = 1; j <= toShow && j <= n; j++) {
            printf wl[j] "  "
        }
        print (n > toShow ? "..." : "")
    }
}
