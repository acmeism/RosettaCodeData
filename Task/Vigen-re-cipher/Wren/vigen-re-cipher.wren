import "./str" for Char, Str

var vigenere = Fn.new { |text, key, encrypt|
    var t = encrypt ? Str.upper(text) : text
    var sb = ""
    var ki = 0
    for (c in t) {
        if (Char.isAsciiUpper(c)) {
            var ci = encrypt ? (c.bytes[0] + key[ki].bytes[0] - 130) % 26 :
                               (c.bytes[0] - key[ki].bytes[0] +  26) % 26
            sb = sb + Char.fromCode(ci + 65)
            ki = (ki + 1) % key.count
        }
    }
    return sb
}

var key = "VIGENERECIPHER"
var text = "Beware the Jabberwock, my son! The jaws that bite, the claws that catch!"
var encoded = vigenere.call(text, key, true)
System.print(encoded)
var decoded = vigenere.call(encoded, key, false)
System.print(decoded)
