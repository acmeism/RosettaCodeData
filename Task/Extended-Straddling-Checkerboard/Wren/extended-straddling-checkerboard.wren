import "./str" for Str

var row1 = "AEINOT"
var row2 = "BCDFGHJKLM"
var row3 = "PQRSUVWXYZ"
var row4 = " ."

var emap = {}
for (i in 0...row1.count) emap[row1[i]] = i.toString
for (i in 0...row2.count) emap[row2[i]] = (70 + i).toString
for (i in 0...row3.count) emap[row3[i]] = (80 + i).toString
for (i in 0...row4.count) emap[row4[i]] = (90 + i).toString
var ewords = {
    "ACK": "92", "REQ": "93", "MSG": "94", "RV": "95",
    "GRID": "96", "SEND": "97", "SUPP": "99"
}
var efigs = "0123456789"
var spc = "90"
var dot = "91"
var fsl = "98"

var dmap = {}
var dwords = {}
for (k in emap.keys) dmap[emap[k]] = k
for (k in ewords.keys) dwords[ewords[k]] = k
var drow1 = "012345"

var encode = Fn.new { |s|
    s = Str.upper(s)
    var res = ""
    var words = s.split(" ")
    var wc = words.count
    for (i in 0...wc) {
        var word = words[i]
        var add = ""
        if (ewords.containsKey(word)) {
            add = ewords[word]
        } else if (ewords.containsKey(word[0...-1]) && word[-1] == ".") {
            add = ewords[word[0...-1]] + dot
        } else if (word.startsWith("CODE")) {
            add = "6" + word[4..-1]
        } else {
            var figs = false
            for (c in word) {
                if (efigs.contains(c)) {
                    if (figs) {
                        add = add + c * 2
                    } else {
                        figs = true
                        add = add + fsl + c * 2
                    }
                } else {
                    var ec = emap[c]
                    if (!ec) {
                        Fiber.abort("Message contains unrecognized character '%(c)'.")
                    }
                    if (figs) {
                        add = add + fsl + ec
                        figs = false
                    } else {
                        add = add + ec
                    }
                }
            }
            if (figs && i < wc - 1) add = add + fsl
        }
        res = res + add
        if (i < wc - 1) res = res + spc
    }
    return res
}

var decode = Fn.new { |s|
    var res = ""
    var sc = s.count
    var figs = false
    var i = 0
    while (i < sc) {
        var c = s[i]
        var ix = -1
        if (figs) {
            if (s[i..i+1] != fsl) {
                res = res + c
            } else {
                figs = false
            }
            i = i + 2
        } else if ((ix = drow1.indexOf(c)) >= 0) {
            res = res + dmap[drow1[ix]]
            i = i + 1
        } else if (c == "6") {
            res = res + "CODE" + s[i+1..i+3]
            i = i + 4
        } else if (c == "7" || c == "8") {
            var d = s[i+1]
            res = res + dmap[c + d]
            i = i + 2
        } else if (c == "9") {
            var d = s[i+1]
            if (d == "0") {
                res = res + " "
            } else if (d == "1") {
                res = res + "."
            } else if (d == "8") {
                figs = !figs
            } else {
                res = res + dwords[c + d]
            }
            i = i + 2
        }
    }
    return res
}

var msg = "Admin ACK your MSG. CODE291 SEND further 2000 SUPP to HQ by 1 March"
System.print("Message:\n%(msg)")
var enc = encode.call(msg)
System.print("\nEncoded:\n%(enc)")
var dec = decode.call(enc)
System.print("\nDecoded:\n%(dec)")
