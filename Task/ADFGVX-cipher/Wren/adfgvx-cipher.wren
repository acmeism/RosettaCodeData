import "random" for Random
import "/ioutil" for FileUtil
import "/seq" for Lst
import "/str" for Char, Str

var rand = Random.new()
var adfgvx = "ADFGVX"
var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".toList

var createPolybius = Fn.new {
    rand.shuffle(alphabet)
    var p = Lst.chunks(alphabet, 6)
    System.print("6 x 6 Polybius square:\n")
    System.print("  | A D F G V X")
    System.print("---------------")
    for (i in 0...p.count) {
        System.write("%(adfgvx[i]) | ")
        System.print(p[i].join(" "))
    }
    return p
}

var createKey = Fn.new { |n|
    if (n < 7 || n > 12) Fiber.abort("Key should be within 7 and 12 letters long.")
    var candidates = FileUtil.readLines("unixdict.txt").where { |word|
        return word.count == n && Lst.distinct(word.toList).count == n &&
               word.all { |ch| Char.isAsciiAlphaNum(ch) }
    }.toList
    var k = Str.upper(candidates[rand.int(candidates.count)])
    System.print("\nThe key is %(k)")
    return k
}

// helper function to sort the key into alphabetical order
// and return a list of the original indices of its letters.
var orderKey = Fn.new { |key|
    var temp = (0...key.count).map { |i| [key[i], i] }.toList
    temp.sort { |x, y| x[0].bytes[0] < y[0].bytes[0] }
    return temp.map { |e| e[1] }.toList
}

var encrypt = Fn.new { |polybius, key, plainText|
    var temp = ""
    for (ch in plainText) {
        var outer = false
        for (r in 0..5) {
            for (c in 0..5) {
                if (polybius[r][c] == ch) {
                    temp = temp + adfgvx[r] + adfgvx[c]
                    outer = true
                    break
                }
            }
            if (outer) break
        }
    }
    var colLen = (temp.count / key.count).floor
    // all columns need to be the same length
    if (temp.count % key.count > 0) colLen = colLen + 1
    var table = Lst.chunks(temp.toList, key.count)
    var lastLen = table[-1].count
    if (lastLen < key.count) table[-1] = table[-1] + ([""] * (key.count - lastLen))
    var order = orderKey.call(key)
    var cols = List.filled(key.count, null)
    for (i in 0...cols.count) {
        cols[i] = List.filled(colLen, null)
        for (j in 0...table.count) cols[i][j] = table[j][order[i]]
    }
    return cols.map { |col| col.join() }.join(" ")
}

var decrypt = Fn.new { |polybius, key, cipherText|
    var colStrs = cipherText.split(" ")
    // ensure all columns are same length
    var maxColLen = colStrs.reduce(0) { |max, col| max = (col.count > max) ? col.count : max }
    var cols = colStrs.map { |s|
        return (s.count < maxColLen) ? s.toList + ([""] * (maxColLen - s.count)) : s.toList
    }.toList
    var table = List.filled(maxColLen, null)
    var order = orderKey.call(key)
    for (i in 0...maxColLen) {
        table[i] = List.filled(key.count, "")
        for (j in 0...key.count) table[i][order[j]] = cols[j][i]
    }
    var temp = table.map { |row| row.join("") }.join("")
    var plainText = ""
    var i = 0
    while (i < temp.count) {
        var r = adfgvx.indexOf(temp[i])
        var c = adfgvx.indexOf(temp[i+1])
        plainText = plainText + polybius[r][c]
        i = i + 2
    }
    return plainText
}

var plainText = "ATTACKAT1200AM"
var polybius = createPolybius.call()
var key = createKey.call(9)
System.print("\nPlaintext : %(plainText)")
var cipherText = encrypt.call(polybius, key, plainText)
System.print("\nEncrypted : %(cipherText)")
var plainText2 = decrypt.call(polybius, key, cipherText)
System.print("\nDecrypted : %(plainText2)")
