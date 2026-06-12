import "./str" for Str, Char
import "./iterate" for Stepped

class Bacon {
    static init() {
        __codes = {
            "a" : "AAAAA", "b" : "AAAAB", "c" : "AAABA", "d" : "AAABB", "e" : "AABAA",
            "f" : "AABAB", "g" : "AABBA", "h" : "AABBB", "i" : "ABAAA", "j" : "ABAAB",
            "k" : "ABABA", "l" : "ABABB", "m" : "ABBAA", "n" : "ABBAB", "o" : "ABBBA",
            "p" : "ABBBB", "q" : "BAAAA", "r" : "BAAAB", "s" : "BAABA", "t" : "BAABB",
            "u" : "BABAA", "v" : "BABAB", "w" : "BABBA", "x" : "BABBB", "y" : "BBAAA",
            "z" : "BBAAB", " " : "BBBAA"  // use " " to denote any non-letter
        }
    }

    static encode(plainText, message) {
        var pt = Str.lower(plainText)
        var sb = ""
        for (c in pt) sb = Char.isLower(c) ? sb + __codes[c] : sb + __codes[" "]
        var et = sb
        sb = ""
        var mg = Str.lower(message) // 'A's to be in lower case, 'B's in upper case
        var count = 0
        for (c in mg) {
            if (Char.isLower(c)) {
                sb = (et[count] == "A") ? sb + c : sb + Char.upper(c)
                count = count + 1
                if (count == et.count) break
            } else {
                sb = sb + c
            }
        }
        return sb
    }

    static decode(message) {
        var sb = ""
        for (c in message) {
            if (Char.isLower(c)) {
                sb = sb + "A"
            } else if (Char.isUpper(c)) {
                sb = sb + "B"
            }
        }
        var et = sb
        sb = ""
        for (i in Stepped.new(0...et.count, 5)) {
            var quintet = Str.sub(et, i...i+5)
            var key = __codes.keys.where { |k| __codes[k] == quintet }.toList[0]
            sb = sb + key
        }
        return sb
    }
}

Bacon.init()
var plainText = "the quick brown fox jumps over the lazy dog"
var message =
    "bacon's cipher is a method of steganography created by francis bacon." +
    "this task is to implement a program for encryption and decryption of " +
    "plaintext using the simple alphabet of the baconian cipher or some " +
    "other kind of representation of this alphabet (make anything signify anything). " +
    "the baconian alphabet may optionally be extended to encode all lower " +
    "case characters individually and/or adding a few punctuation characters " +
    "such as the space."
var cipherText = Bacon.encode(plainText, message)
System.print("Cipher text ->\n\n%(cipherText)")
var decodedText = Bacon.decode(cipherText)
System.print("\nHidden text ->\n\n%(decodedText)")
