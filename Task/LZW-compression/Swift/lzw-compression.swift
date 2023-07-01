class LZW {
    class func compress(_ uncompressed:String) -> [Int] {
        var dict = [String : Int]()

        for i in 0 ..< 256 {
            let s = String(Unicode.Scalar(UInt8(i)))
            dict[s] = i
        }

        var dictSize = 256
        var w = ""
        var result = [Int]()
        for c in uncompressed {
            let wc = w + String(c)
            if dict[wc] != nil {
                w = wc
            } else {
                result.append(dict[w]!)
                dict[wc] = dictSize
                dictSize += 1
                w = String(c)
            }
        }

        if w != "" {
            result.append(dict[w]!)
        }
        return result
    }

    class func decompress(_ compressed:[Int]) -> String? {
        var dict = [Int : String]()

        for i in 0 ..< 256 {
            dict[i] = String(Unicode.Scalar(UInt8(i)))
        }

        var dictSize = 256
        var w = String(Unicode.Scalar(UInt8(compressed[0])))
        var result = w
        for k in compressed[1 ..< compressed.count] {
            let entry : String
            if let x = dict[k] {
                entry = x
            } else if k == dictSize {
                entry = w + String(w[w.startIndex])
            } else {
                return nil
            }

            result += entry
            dict[dictSize] = w + String(entry[entry.startIndex])
            dictSize += 1
            w = entry
        }
        return result
    }
}

let comp = LZW.compress("TOBEORNOTTOBEORTOBEORNOT")
print(comp)

if let decomp = LZW.decompress(comp) {
    print(decomp)
}
