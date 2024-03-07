import "./pattern" for Pattern

var s = "\t\n\r\x01\0\fabc\v\v\b\a\x1f\x7f🌇Páez😃É"

// strip control codes only
var p = Pattern.new("+1/c")
var r = p.replaceAll(s, "")
System.print("%(r) -> length %(r.count)")

// strip extended characters as well
p = Pattern.new("[+1/c|+1/R]")
r = p.replaceAll(s, "")
System.print("%(r) -> length %(r.count)")
