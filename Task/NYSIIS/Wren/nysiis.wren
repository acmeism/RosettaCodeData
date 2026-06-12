import "./str" for Str
import "./pattern" for Pattern
import "./fmt" for Fmt

var fStrs = [["MAC", "MCC"], ["KN", "N"], ["K", "C"], ["PH", "FF"], ["PF", "FF"], ["SCH", "SSS"]]
var lStrs = [["EE", "Y"], ["IE", "Y"], ["DT", "D"], ["RT", "D"], ["RD", "D"], ["NT", "D"], ["ND", "D"]]
var mStrs = [["EV", "AF"], ["KN", "N"], ["SCH", "SSS"], ["PH", "FF"]]
var eStrs = ["JR", "JNR", "SR", "SNR"]

var isVowel = Fn.new { |c| "AEIOU".contains(c) }

var isRoman = Fn.new { |s| s.all { |c| "IVX".contains(c) } }

var splitter = Pattern.new("[ |,]")

var nysiis = Fn.new { |word|
    if (word == "") return word
    var w = Str.upper(word)
    var ww = splitter.splitAll(w)
    if (ww.count > 1 && isRoman.call(ww[-1])) w = w[0...w.count-ww[-1].count]
    for (c in " ,'-") w = w.replace(c, "")
    for (eStr in eStrs) {
        if (w.endsWith(eStr)) w = w[0...w.count-eStr.count]
    }
    for (fStr in fStrs) {
        if (w.startsWith(fStr[0])) w = fStr[1] + w[fStr[0].count..-1]
    }
    for (lStr in lStrs) {
        if (w.endsWith(lStr[0])) w = w[0..-3] + lStr[1]
    }
    var key = w[0]
    w = w[1..-1]
    for (mStr in mStrs) w = w.replace(mStr[0], mStr[1])
    var sb = (key[0] + w).toList
    var i = 1
    var len = sb.count
    while (i < len) {
        if ("EIOU".contains(sb[i])) {
            sb[i] = "A"
        } else if (sb[i] == "Q") {
            sb[i] = "G"
        } else if (sb[i] == "Z") {
            sb[i] = "S"
        } else if (sb[i] == "M") {
            sb[i] = "N"
        } else if (sb[i] == "K") {
            sb[i] = "C"
        } else if (sb[i] == "H") {
            if (!isVowel.call(sb[i-1]) || (i < len-1 && !isVowel.call(sb[i+1]))) sb[i] = sb[i-1]
        } else if (sb[i] == "W") {
            if (isVowel.call(sb[i-1])) sb[i] = "A"
        }
        if (sb[i] != sb[i-1]) {
            i = i + 1
        } else {
            sb.removeAt(i)
            len = len - 1
        }
    }
    if (sb[len-1] == "S") {
        sb = sb[0...len-1]
        len = len - 1
    }
    if (len > 1 && Str.sub(sb.join(""), len-2..-1) == "AY") {
        sb = sb[0...len-2]
        sb = sb + ["Y"]
        len = len -1
    }
    if (len > 0 && sb[len-1] == "A") {
        sb = sb[0...len-1]
        len = len - 1
    }
    var prev = key[0]
    for (j in 1...len) {
        var c = sb[j]
        if (prev != c) {
            key = key + c
            prev = c
        }
    }
    return key
}

var names = [
    "Bishop", "Carlson", "Carr", "Chapman",
    "Franklin", "Greene", "Harper", "Jacobs", "Larson", "Lawrence",
    "Lawson", "Louis, XVI", "Lynch", "Mackenzie", "Matthews", "May jnr",
    "McCormack", "McDaniel", "McDonald", "Mclaughlin", "Morrison",
    "O'Banion", "O'Brien", "Richards", "Silva", "Watkins", "Xi",
    "Wheeler", "Willis", "brown, sr", "browne, III", "browne, IV",
    "knight", "mitchell", "o'daniel", "bevan", "evans", "D'Souza",
    "Hoyle-Johnson", "Vaughan Williams", "de Sousa", "de la Mare II"
]

for (name in names) {
    var name2 = nysiis.call(name)
    if (name2.count > 6) name2 = Fmt.swrite("$s($s)", name2[0..5], name2[6..-1])
    Fmt.print("$-16s : $s", name, name2)
}
