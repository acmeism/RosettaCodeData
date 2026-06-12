import BigInt // https://github.com/attaswift/BigInt or similar
import Foundation

func cumulativeFreq(_ freq: [UInt8: Int]) -> [UInt8: Int] {
    var total = 0
    var cf = [UInt8: Int]()
    for i in UInt8.min ... UInt8.max {
        let c = i
        let v = freq[c]
        if let v {
            cf[c] = total
            total += v
        }
    }
    return cf
}

func arithmeticCoding(_ str: String, _ radix: Int) -> (BigInt, Int, [UInt8: Int]) {
    // Convert the string into a char array
    let chars = str.utf8.map({$0})

    // The frequency characters
    var freq = [UInt8: Int]()
    for c in chars {
        freq[c, default: 0] += 1
    }

    // The cumulative frequency
    let cf = cumulativeFreq(freq)

    // Base
    let base = BigInt(chars.count)

    // LowerBound
    var lower = BigInt.zero

    // Product of all frequencies
    var pf = BigInt(1)

    // Each term is multiplied by the product of the
    // frequencies of all previously occurring symbols
    for c in chars {
        let x = BigInt(cf[c]!)
        lower = lower * base + x * pf
        pf *= BigInt(freq[c]!)
    }

    // Upper bound
    let upper = lower + pf

    var powr = 0
    let bigRadix = BigInt(radix)

    while true {
        pf /= bigRadix
        if (pf == BigInt.zero) {
            break
        }
        powr += 1
    }

    let diff = (upper - BigInt(1)) / pow(bigRadix, powr)
    return (diff, powr, freq)
}

func arithmeticDecoding(_ num: BigInt, _ radix: Int, _ pwr: Int, _ freq: [UInt8: Int]) -> String {
    let powr = BigInt(radix)
    var enc = num * pow(powr, pwr)
    var base = 0
    for (_, v) in freq {
        base += v
    }

    // Create the cumulative frequency table
    let cf = cumulativeFreq(freq)

    // Create the dictionary
    var dict = Dictionary<Int, UInt8>()
    for (k, v) in cf {
        dict[v] = k
    }

    // Fill the gaps in the dictionary
    var lchar: UInt8? = nil
    for i in 0 ..< base {
        let v = dict[i]
        if let v {
            lchar = v
        } else if let lchar {
            dict[i] = lchar
        }
    }

    // Decode the input number
    var decoded = [UInt8]()
    let bigBase = BigInt(base)
    for i in (0 ..< base).reversed()  {
        let pow = pow(bigBase, i)
        let div = enc / pow
        let c = dict[Int(div)]!
        let fv = BigInt(freq[c]!)
        let cv = BigInt(cf[c]!)
        let diff = enc - pow * cv
        enc = diff / fv
        decoded.append(c)
    }
    // Return the decoded output
    return String(decoding: decoded, as: UTF8.self)
}

func pow<T: BinaryInteger, U: BinaryInteger>(_ base: T, _ power: U) -> T {
    var tempBase = base
    var tempPower = power
    var result: T = 1

    while tempPower != 0 {
        if tempPower % 2 == 1 {
            result *= tempBase
        }
        tempPower = tempPower >> 1
        tempBase *= tempBase
    }
    return result
}

let radix = 10
let strings = [
    "DABDDB", "DABDDBBDDBA", "ABRACADABRA", "TOBEORNOTTOBEORTOBEORNOT"
]
for str in strings {
    let (enc, pow, freq) = arithmeticCoding(str, radix)
    print("\(str) => \(enc) * \(radix)^\(pow)")
    let dec = arithmeticDecoding(enc, radix, pow, freq)
    if str != dec {
        print("\tHowever that is incorrect! \(str) != \(dec)")
        exit(EXIT_FAILURE)
    }
}
