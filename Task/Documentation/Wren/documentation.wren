// The meaning of life!
var mol = 42

// A function to add two numbers
var add = Fn.new { |x, y| x + y }

/* A class with some string utilites */
class StrUtil {
    // reverses an ASCII string
    static reverse(s) { s[-1..0] }

    // capitalizes the first letter of an ASCII string
    static capitalize(s) {
        var firstByte = s[0].bytes[0]
        if (firstByte >= 97 && firstByte <= 122) {
            firstByte = firstByte - 32
            return String.fromByte(firstByte) + s[1..-1]
        }
        return s
    }
}

// test code
var smol = "meaning of life"
System.print("'%(smol)' + 123       = %(add.call(mol, 123))")
System.print("'%(smol)' reversed    = %(StrUtil.reverse(smol))")
System.print("'%(smol)' capitalized = %(StrUtil.capitalize(smol))")
