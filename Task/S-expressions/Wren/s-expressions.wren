import "./pattern" for Pattern
import "./fmt" for Fmt

var INDENT = 2

var parseSExpr = Fn.new { |str|
    var ipat = " \t\n\f\v\r()\""
    var p = Pattern.new("""+0/s["+0^""|(|)|"|+1/I]""", Pattern.within, ipat)
    var t = p.findAll(str).map { |m| m.text }.toList
    if (t.count == 0) return null
    var o = false
    var c = 0
    for (i in t.count-1..0) {
        var ti = t[i].trim()
        var nd = Num.fromString(ti)
        if (ti == "\"") return null
        if (ti == "(") {
            t[i] = "["
            c = c + 1
        } else if (ti == ")") {
            t[i] = "]"
            c = c - 1
        } else if (nd) {
            var ni = Num.fromString(ti)
            t[i] = ni ? ni.toString : nd.toString
        } else if (ti.startsWith("\"")) { // escape embedded double quotes
            var temp = ti[1...-1]
            t[i] = "\"" + temp.replace("\"", "\\\"") + "\""
        }
        if (i > 0 && t[i] != "]" && t[i - 1].trim() != "(") t.insert(i, ", ")
        if (c == 0) {
            if (!o) o = true else return null
        }
    }
    return (c != 0) ? null : t
}

var toSExpr = Fn.new { |tokens|
    for (i in 0...tokens.count) {
        if (tokens[i] == "[") {
            tokens[i] = "("
        } else if (tokens[i] == "]") {
            tokens[i] = ")"
        } else if (tokens[i] == ", ") {
            tokens[i] = " "
        } else if (tokens[i].startsWith("\"")) { // unescape embedded quotes
            var temp = tokens[i][1...-1]
            tokens[i] = "\"" + temp.replace("\\\"", "\"") + "\""
        }
    }
    return tokens.join()
}

var prettyPrint = Fn.new { |tokens|
    var level = 0
    for (t in tokens) {
        var n
        if (t == ", " || t == " ") {
            continue
        } else if (t == "[" || t == "(") {
            n = level * INDENT + 1
            level = level + 1
        } else if (t == "]" || t == ")") {
            level = level - 1
            n = level * INDENT + 1
        } else {
            n = level * INDENT + t.count
        }
        Fmt.print("$*s", n, t)
    }
}

var str = """((data "quoted data" 123 4.5)""" + "\n" +
          """ (data (!@# (4.5) "(more" "data)")))"""
var tokens = parseSExpr.call(str)
if (!tokens) {
    System.print("Invalid s-expr!")
} else {
    System.print("Native data structure:")
    System.print(tokens.join())
    System.print("\nNative data structure (pretty print):")
    prettyPrint.call(tokens)

    System.print("\nRecovered S-Expression:")
    System.print(toSExpr.call(tokens))
    System.print("\nRecovered S-Expression (pretty print):")
    prettyPrint.call(tokens)
}
