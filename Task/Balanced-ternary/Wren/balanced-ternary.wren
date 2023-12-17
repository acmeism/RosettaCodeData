import "./big" for BigInt
import "./trait" for Comparable

class BTernary is Comparable {
    toBT_(v) {
        if (v < BigInt.zero) return flip_(toBT_(-v))
        if (v == BigInt.zero) return ""
        var rem = mod3_(v)
        return (rem == BigInt.zero) ? toBT_(v/BigInt.three) + "0" :
               (rem == BigInt.one)  ? toBT_(v/BigInt.three) + "+" :
                       toBT_((v + BigInt.one)/BigInt.three) + "-"
    }

    flip_(s) {
        var sb = ""
        for (c in s) {
            sb = sb + ((c == "+") ? "-" : (c == "-") ? "+" : "0")
        }
        return sb
    }

    mod3_(v) {
        if (v > BigInt.zero) return v % BigInt.three
        return ((v % BigInt.three) + BigInt.three) % BigInt.three
    }

    addDigits2_(a, b) {
        return (a == "0") ? b :
               (b == "0") ? a :
               (a == "+") ? ((b == "+") ? "+-" : "0") :
                             (b == "+") ? "0" : "-+"
    }

    addDigits3_(a, b, carry) {
        var sum1 = addDigits2_(a, b)
        var sum2 = addDigits2_(sum1[-1], carry)
        return (sum1.count == 1) ? sum2 : (sum2.count == 1) ? sum1[0] + sum2 : sum1[0]
    }

    construct new(value) {
        if (value is String && value.all { |c| "0+-".contains(c) }) {
            _value = value.trimStart("0")
        } else if (value is BigInt) {
            _value = toBT_(value)
        } else if (value is Num && value.isInteger) {
            _value = toBT_(BigInt.new(value))
        } else {
            Fiber.abort("Invalid argument.")
        }
    }

    value { _value }

    +(other) {
        var a = _value
        var b = other.value
        var longer = (a.count > b.count) ? a : b
        var shorter = (a.count > b.count) ? b : a
        while (shorter.count < longer.count) shorter = "0" + shorter
        a = longer
        b = shorter
        var carry = "0"
        var sum = ""
        for (i in 0...a.count) {
            var place = a.count - i - 1
            var digisum = addDigits3_(a[place], b[place], carry)
            carry = (digisum.count != 1) ? digisum[0] : "0"
            sum = digisum[-1] + sum
        }
        sum = carry + sum
        return BTernary.new(sum)
    }

    - { BTernary.new(flip_(_value)) }

    -(other) { this + (-other) }

    *(other) {
        var that = other.clone()
        var one = BTernary.new(1)
        var zero = BTernary.new(0)
        var mul = zero
        var flipFlag = false
        if (that < zero) {
            that = -that
            flipFlag = true
        }
        var i = one
        while (i <= that) {
            mul = mul + this
            i = i + one
        }
        if (flipFlag) mul = -mul
        return mul
    }

    toBigInt {
        var len = _value.count
        var sum = BigInt.zero
        var pow = BigInt.one
        for (i in 0...len) {
            var c = _value[len-i-1]
            var dig = (c == "+") ? BigInt.one : (c == "-") ? BigInt.minusOne : BigInt.zero
            if (dig != BigInt.zero) sum = sum + dig*pow
            pow = pow * BigInt.three
        }
        return sum
    }

    compare(other) { this.toBigInt.compare(other.toBigInt) }

    clone() { BTernary.new(_value) }

    toString { _value }
}

var a = BTernary.new("+-0++0+")
var b = BTernary.new(-436)
var c = BTernary.new("+-++-")
System.print("a = %(a.toBigInt)")
System.print("b = %(b.toBigInt)")
System.print("c = %(c.toBigInt)")
var bResult = a * (b - c)
var iResult = bResult.toBigInt
System.print("a * (b - c) = %(bResult) = %(iResult)")
