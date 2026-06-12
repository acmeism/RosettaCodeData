import "./fmt" for Fmt

class GSTrans {
    static encode(s, upper) {
        if (!(s is String && s.count > 0)) Fiber.abort("Argument must be a non-empty string.")

        // remove any outer quotation marks
        if (s.count > 1 && s[0] == "\"" && s[-1] == "\"") s = s[1..-2]

        // helper function to encode bytes < 128
        var f = Fn.new { |b|
            if (b >= 1 && b <= 26) {
                return "|" + (upper ? String.fromByte(b + 64) : String.fromByte(b + 96))
            } else if (b < 32) {
                return "|" + String.fromByte(b + 64)
            } else if (b == 34)  { // quotation mark
                return "|\""
            } else if (b == 60)  { // less than
                return "|<"
            } else if (b == 124) { // vertical bar
                return "||"
            } else if (b == 127) { // DEL
                return "|?"
            } else {
                return String.fromByte(b)
            }
         }

         var enc = ""

         // iterate through the string's bytes encoding as we go
         for (b in s.bytes) {
             if (b < 128) {
                enc = enc + f.call(b)
             } else {
                enc = enc + "|!" + f.call(b - 128)
             }
         }

         return enc
    }

    static decode(s) {
        if (!(s is String && s.count > 0)) Fiber.abort("Argument must be a non-empty string.")

        // remove any outer quotation marks
        if (s.count > 1 && s[0] == "\"" && s[-1] == "\"") s = s[1..-2]

        // helper function for decoding bytes after "|"
        var f = Fn.new { |b|
            if (b == 34)                     { // quotation mark
                return 34
            } else if (b == 60)              { // less than
                return 60
            } else if (b == 63)              { // question mark
                return 127
            } else if (b >= 64 && b < 96)    { // @ + upper case letter + [\]^_
                return b - 64
            } else if (b == 96)              { // grave accent
                return 31
            } else if (b == 124)             { // vertical bar
                return 124
            } else if (b >= 97 && b < 127)   { // lower case letter + {}~
                return b - 96
            } else {
                return b
            }
        }

        var bytes = s.bytes.toList
        var bc = bytes.count
        var i = 0
        var dec = ""

        // iterate through the string's bytes decoding as we go
        while (i < bc) {
            if (bytes[i] != 124) {
                dec = dec + String.fromByte(bytes[i])
                i = i + 1
            } else {
                if (i < bc - 1 && bytes[i+1] != 33) {
                    dec = dec + String.fromByte(f.call(bytes[i+1]))
                    i = i + 2
                } else {
                    if (i < bc - 2 && bytes[i+2] != 124) {
                        dec = dec + String.fromByte(128 + bytes[i+2])
                        i = i + 3
                    } else if (i < bc - 3 && bytes[i+2] == 124) {
                        dec = dec + String.fromByte(128 + f.call(bytes[i+3]))
                        i = i + 4
                    } else {
                        i = i + 1
                    }
                }
            }
        }
        return dec
    }
}

var strings = [
    "\fHello\a\n\r",
    "\r\n\0\x05\xf4\r\xff"
]

var uppers = [true, false]

for (i in 0...strings.count) {
    var s = strings[i]
    var t = Fmt.swrite("$q", Fmt.B(0, s))
    var u = uppers[i]
    var enc = GSTrans.encode(s, u)
    var dec = GSTrans.decode(enc)
    var d = Fmt.swrite("$q", Fmt.B(0, dec))
    System.print("string: %(t)")
    System.print("encoded (%(u ? "upper" : "lower")) : %(enc)")
    System.print("decoded : %(d)")
    System.print("string == decoded ? %(dec == s)\n")
}

var jstrings = [
    "ALERT|G",
    "wert↑",
    "@♂aN°$ª7Î",
    "ÙC▼æÔt6¤☻Ì",
    "\"@)Ð♠qhýÌÿ",
    "+☻#o9$u♠©A",
    "♣àlæi6Ú.é",
    "ÏÔ♀È♥@ë",
    "Rç÷\%◄MZûhZ",
    "ç>¾AôVâ♫↓P"
]

System.print("Julia strings: string -> encoded (upper) <- decoded (same or different)\n")
for (s in jstrings) {
    var enc = GSTrans.encode(s, true)
    var dec = GSTrans.decode(enc)
    var same = (s == dec)
    System.print("  %(s) -> %(enc) <- %(dec) (%(same ? "same" : "different"))")
}
