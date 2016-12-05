class LZW {
  class func compress(uncompressed:String) -> [Int] {
    var dict = [String : Int]()

    for i in 0 ..< 256 {
      let s = String(UnicodeScalar(i))
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
        dict[wc] = dictSize++
        w = String(c)
      }
    }

    if w != "" {
      result.append(dict[w]!)
    }
    return result
  }

  class func decompress(compressed:[Int]) -> String? {
    var dict = [Int : String]()

    for i in 0 ..< 256 {
      dict[i] = String(UnicodeScalar(i))
    }

    var dictSize = 256
    var w = String(UnicodeScalar(compressed[0]))
    var result = w
    for k in compressed[1 ..< compressed.count] {
      let entry : String
      if let x = dict[k] {
        entry = x
      } else if k == dictSize {
        entry = w + String(first(w)!)
      } else {
        return nil
      }

      result += entry
      dict[dictSize++] = w + String(first(entry)!)
      w = entry
    }
    return result
  }
}

let comp = LZW.compress("TOBEORNOTTOBEORTOBEORNOT")
println(comp)
if let decomp = LZW.decompress(comp) {
  println(decomp)
}
