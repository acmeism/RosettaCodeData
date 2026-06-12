import "io" for File, Stdout
import "./fmt" for Conv, Fmt
import "./seq" for Lst

var alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

var encode = Fn.new { |s|
   var c = s.count
   if (c == 0) return s
   var e = ""
   for (b in s) e = e + Fmt.swrite("$08b", b)
   if (c == 2) {
        e = e + "00"
   } else if (c == 1) {
        e = e + "0000"
   }
   var i = 0
   while (i < e.count) {
       var ix = Conv.atoi(e[i..i+5], 2)
       System.write(alpha[ix])
       i = i + 6
   }
   if (c == 2) {
       System.write("=")
   } else if (c == 1) {
       System.write("==")
   }
   Stdout.flush()
}

var s = File.read("favicon.ico").bytes.toList
for (chunk in Lst.chunks(s, 3)) encode.call(chunk)
System.print()
