import Foundation

typealias Byte = UInt8

func deBruijn(_ k: Int, _ n: Int) -> String {
    var a = Array(repeating: Byte(0), count: k * n)
    var seq: [Byte] = []

    func db(_ t: Int, _ p: Int) {
        if t > n {
            if n % p == 0 {
                for i in 1..<p + 1 {
                    seq.append(a[i])
                }
            }
        } else {
            a[t] = a[t - p]
            db(t + 1, p)
            var j = Int(a[t - p]) + 1
            while j < k {
                a[t] = Byte(j & 0xFF)
                db(t + 1, t)
                j += 1
            }
        }
    }

    db(1, 1)
    var buf = ""
    for i in seq {
        buf.append(Character(UnicodeScalar(UInt8(i) + UInt8(ascii: "0")) ?? UnicodeScalar(0)))
    }
    return buf + String(buf.prefix(n - 1))
}

func allDigits(_ s: String) -> Bool {
    for c in s {
        if c < "0" || "9" < c {
            return false
        }
    }
    return true
}

func validate(_ db: String) {
    let le = db.count
    var found = Array(repeating: 0, count: 10000)
    var errs: [String] = []

    // Check all strings of 4 consecutive digits within 'db'
    // to see if all 10,000 combinations occur without duplication.
    for i in 0..<(le - 3) {
        let startIndex = db.index(db.startIndex, offsetBy: i)
        let endIndex = db.index(startIndex, offsetBy: 4)
        let s = String(db[startIndex..<endIndex])
        if allDigits(s) {
            if let n = Int(s) {
                found[n] += 1
            }
        }
    }

    for i in 0..<10000 {
        if found[i] == 0 {
            errs.append("    PIN number \(i) missing")
        } else if found[i] > 1 {
            errs.append("    PIN number \(i) occurs \(found[i]) times")
        }
    }

    if errs.isEmpty {
        print("  No errors found")
    } else {
        let pl = (errs.count == 1) ? "" : "s"
        print("  \(errs.count) error\(pl) found:")
        for e in errs {
            print(e)
        }
    }
}

func main() {
    let db = deBruijn(10, 4)

    print("The length of the de Bruijn sequence is \(db.count)\n")
    print("The first 130 digits of the de Bruijn sequence are: \(String(db.prefix(130)))\n")
    print("The last 130 digits of the de Bruijn sequence are: \(String(db.suffix(130)))")

    print("\nValidating the de Bruijn sequence:")
    validate(db)

    print("\nValidating the reversed de Bruijn sequence:")
    let rdb = String(db.reversed())
    validate(rdb)

    var by = Array(db)
    by[4443] = "."
    let overlaidDb = String(by)
    print("\nValidating the overlaid de Bruijn sequence:")
    validate(overlaidDb)
}

main()
