import "io" for Stdout
import "./fmt" for Conv, Fmt
import "./str" for Str

var alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

var decode = Fn.new { |s|
   if (s == "") return s
   var d = ""
   for (b in s) {
       var ix = alpha.indexOf(b)
       if (ix >= 0) d = d + Fmt.swrite("$06b", ix)
   }
   if (s.endsWith("==")) {
        d = d[0..-5]
   } else if (s.endsWith("=")){
        d = d[0..-3]
   }
   var i = 0
   while (i < d.count) {
        var ch = String.fromByte(Conv.atoi(d[i..i+7], 2))
        System.write(ch)
        i = i + 8
   }
   Stdout.flush()
}

var s = "VG8gZXJyIGlzIGh1bWFuLCBidXQgdG8gcmVhbGx5IGZvdWwgdGhpbmdzIHVwIHlvdSBuZWVkIGEgY29tcHV0ZXIuCiAgICAtLSBQYXVsIFIuIEVocmxpY2g="
for (chunk in Str.chunks(s, 4)) decode.call(chunk)
System.print()
