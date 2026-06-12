import "./big" for BigInt
import "./fmt" for Fmt

var cumulativeFreq = Fn.new { |freq|
    var total = 0
    var cf = {}
    for (i in 0..255) {
        var c = i
        var v = freq[c]
        if (v) {
            cf[c] = total
            total = total + v
        }
    }
    return cf
}

var arithmeticCoding = Fn.new { |str, radix|
    // Convert the string into a character list
    var chars = str.bytes.toList

    // The frequency characters
    var freq = {}
    for (c in chars) {
        if (!freq[c]) {
            freq[c] = 1
        } else {
            freq[c] = freq[c] + 1
        }
    }

    // The cumulative frequency
    var cf = cumulativeFreq.call(freq)

    // Base
    var base = BigInt.new(chars.count)

    // LowerBound
    var lower = BigInt.zero

    // Product of all frequencies
    var pf = BigInt.one

    // Each term is multiplied by the product of the
    // frequencies of all previously occurring symbols
    for (c in chars) {
        var x = BigInt.new(cf[c])
        lower  = lower * base + x * pf
        pf = pf * BigInt.new(freq[c])
    }

    // Upper bound
    var upper = lower + pf

    var powr = 0
    var bigRadix = BigInt.new(radix)

    while (true) {
        pf = pf / bigRadix
        if (pf == BigInt.zero) break
        powr = powr + 1
    }

    var diff = (upper - BigInt.one) / bigRadix.pow(powr)
    return [diff, powr, freq]
}

var arithmeticDecoding = Fn.new { |num, radix, pwr, freq|
    var powr = BigInt.new(radix)
    var enc = num * powr.pow(pwr)
    var base = 0
    for (v in freq.values) base = base + v

    // Create the cumulative frequency table
    var cf = cumulativeFreq.call(freq)

    // Create the dictionary
    var dict = {}
    for (me in cf) dict[me.value] = me.key

    // Fill the gaps in the dictionary
    var lchar = -1
    for (i in 0...base) {
        var v = dict[i]
        if (v) {
            lchar = v
        } else if (lchar != -1) {
            dict[i] = lchar
        }
    }

    // Decode the input number
    var decoded = ""
    var bigBase = BigInt.new(base)
    for (i in base-1..0) {
        var pow = bigBase.pow(i)
        var div = enc / pow
        var c = dict[div.toSmall]
        var fv = BigInt.new(freq[c])
        var cv = BigInt.new(cf[c])
        var diff = enc - pow * cv
        enc = diff / fv
        decoded = decoded + String.fromByte(c)
    }
    // Return the decoded output
    return decoded
}

var radix = 10
var strings = ["DABDDB", "DABDDBBDDBA", "ABRACADABRA", "TOBEORNOTTOBEORTOBEORNOT"]
var fmt = "$-25s=> $19s * $d^$s"
for (str in strings) {
    var res  = arithmeticCoding.call(str, radix)
    var enc  = res[0]
    var pow  = res[1]
    var freq = res[2]
    var dec = arithmeticDecoding.call(enc, radix, pow, freq)
    Fmt.print(fmt, str, enc, radix, pow)
    if (str != dec) Fiber.abort("\tHowever that is incorrect!")
}
