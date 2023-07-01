import "./regex" for Regex

var s = "abracadabra"
var split = Regex.compile("a").split(s)
var repl = "ABaCD"
var res = ""
for (i in 0...split.count-1) res = res + split[i] + repl[i]
s = res + split[-1]
s = Regex.compile("b").replace(s, "E")
s = Regex.compile("r").replaceAll(s, "F", 2, 1)
System.print(s)
