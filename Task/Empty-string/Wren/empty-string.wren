var isEmpty = Fn.new { |s| s == "" }

var s = ""
var t = "0"
System.print("'s' is empty? %(isEmpty.call(s))")
System.print("'t' is empty? %(isEmpty.call(t))")
