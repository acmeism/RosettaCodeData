import std

// Very basic arbitrary-precision integers
// - only non-negative numbers
// - doesn't implement any arithmetic not necessary for the task at hand...

let base = 1000000000

class Bign:
    digits: [int] // little endian, of base base
    digitsUsed: int

    def clone():
        return Bign { digits: copy(digits), digitsUsed: digitsUsed }

    def resize(newLength):
        while digits.length < newLength:
            digits.push(0)

    def adjustDigitsUsed():
        while digitsUsed > 0 and digits[digitsUsed - 1] == 0:
                digitsUsed -= 1

    // multiplication by one digit; used to convert string to Bign
    def muldigit(multiplier : int):
        if (multiplier < 0):
            return // "Signed arithmetic isn't supported"
        resize(digitsUsed + 1)
        var temp = 0
        for(digitsUsed) i:
            temp += digits[i] * multiplier
            digits[i] = temp % base
            temp /= base
        digits[digitsUsed] = temp
        digitsUsed += 1
        adjustDigitsUsed()

    // addition of one digit; used to convert string to Bign
    def adddigit(addend: int):
        if (addend < 0):
            return // "Signed arithmetic isn't supported"
        var temp = addend
        var i = 0
        while i < digitsUsed and temp != 0:
            temp += digits[i]
            digits[i] = temp % base
            temp /= base
            i += 1
        if temp != 0:
            resize(digitsUsed + 1)
            digits[digitsUsed] = temp
            digitsUsed += 1

    def bign2str():
        var i = digitsUsed
        if i == 0:
            return "0"
        i -= 1
        var s = string(digits[i])
        while i > 0:
            i -= 1
            s += number_to_string(digits[i], 10, 9)
        return s

def str2bign(value):
    // each of our Bign digits can store 9 decimal digits
    let this = Bign { digits: map(value.length() / 9 + 1): 0, digitsUsed: 0 }
    // handle nine digits at a time
    var i = 0
    while i < value.length:
        var multiplier = 1
        var addend = 0
        for(min(9, value.length() - i)) j:
            let c = value[i+j]
            //if (c < '0' or c > '9') -- what!?
            multiplier *= 10
            addend *= 10
            addend += c - '0'
        this.muldigit(multiplier)
        this.adddigit(addend)
        i += 9
    return this

// Long multiplication

def bign_multiply(this, multiplier):
    // Make sure the shorter number is on the right side to make things a bit more efficient
    let left  = if (this.digitsUsed > multiplier.digitsUsed): this else: multiplier
    let right = if (this.digitsUsed > multiplier.digitsUsed): multiplier else: this
    let newDigits = map(left.digitsUsed + right.digitsUsed): 0
    for(right.digitsUsed) rightPos:
        let rightDigit = right.digits[rightPos]
        var temp = 0
        for(left.digitsUsed) leftPos:
            temp += newDigits[leftPos + rightPos]
            temp += rightDigit * left.digits[leftPos]
            newDigits[leftPos + rightPos] = temp % base
            temp /= base
        // Roll forward any carry we may have
        let destPos = rightPos + left.digitsUsed
        while temp != 0:
            temp += newDigits[destPos]
            newDigits[destPos] = temp % base
            temp /= base
            destPos +- 1
    let bign = Bign { digits: newDigits, digitsUsed: newDigits.length }
    bign.adjustDigitsUsed()
    return bign

let one = str2bign("18446744073709551616")
let two = one.clone()
var pro = one.bign_multiply(two)
print(bign2str(pro))
