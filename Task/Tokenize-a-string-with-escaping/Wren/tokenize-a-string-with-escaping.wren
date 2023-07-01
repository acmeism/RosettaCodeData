var SPE = "\ufffe"  // unused unicode character in Specials block
var SPF = "\uffff"  // ditto

var tokenize = Fn.new { |str, sep, esc|
    str = str.replace(esc + esc, SPE).replace(esc + sep, SPF)
    str = (str[-1] == esc) ? str[0...-1].replace(esc, "") + esc : str.replace(esc, "")
    return str.split(sep).map { |s| s.replace(SPE, esc).replace(SPF, sep) }.toList
}

var str = "one^|uno||three^^^^|four^^^|^cuatro|"
var sep = "|"
var esc = "^"
var items = tokenize.call(str, sep, esc)
for (item in items) System.print((item == "") ? "(empty)" : item)
