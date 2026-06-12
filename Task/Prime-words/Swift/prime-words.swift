import Foundation

class BitArray {
    var array: [UInt32]

    init(size: Int) {
        array = Array(repeating: 0, count: (size + 31)/32)
    }

    func get(index: Int) -> Bool {
        let bit = UInt32(1) << (index & 31)
        return (array[index >> 5] & bit) != 0
    }

    func set(index: Int, value: Bool) {
        let bit = UInt32(1) << (index & 31)
        if value {
            array[index >> 5] |= bit
        } else {
            array[index >> 5] &= ~bit
        }
    }
}

class PrimeSieve {
    let composite: BitArray

    init(size: Int) {
        composite = BitArray(size: size/2)
        var p = 3
        while p * p <= size {
            if !composite.get(index: p/2 - 1) {
                let inc = p * 2
                var q = p * p
                while q <= size {
                    composite.set(index: q/2 - 1, value: true)
                    q += inc
                }
            }
            p += 2
        }
    }

    func isPrime(number: Int) -> Bool {
        if number < 2 {
            return false
        }
        if (number & 1) == 0 {
            return number == 2
        }
        return !composite.get(index: number/2 - 1)
    }
}

func loadDictionary(_ path: String) throws -> [String] {
    let contents = try String(contentsOfFile: path, encoding: String.Encoding.ascii)
    return contents.components(separatedBy: "\n").filter{!$0.isEmpty}
}

do {
    let dictionary = try loadDictionary("unixdict.txt")
    let sieve = PrimeSieve(size: 255)
    for word in dictionary {
        if word.allSatisfy({$0.isASCII && sieve.isPrime(number: Int($0.asciiValue!))}) {
            print(word)
        }
    }
} catch {
    print(error.localizedDescription)
}
