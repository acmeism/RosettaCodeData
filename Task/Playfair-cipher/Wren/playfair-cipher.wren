import "/dynamic" for Enum
import "/str" for Str, Char
import "/iterate" for Stepped
import "/ioutil" for Input

var PlayfairOption = Enum.create("PlayfairOption", ["NO_Q", "I_EQUALS_J"])

class Playfair {
    construct new(keyword, pfo) {
        _pfo = pfo
        // build_table
        _table = List.filled(5, null)
        for (i in 0..4) _table[i] = List.filled(5, "\0") // 5 * 5 char list
        var used = List.filled(26, false)
        if (_pfo == PlayfairOption.NO_Q) {
            used[16] = true // Q used
        } else {
            used[9]  = true // J used
        }
        var alphabet = Str.upper(keyword) + "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var i = 0
        var j = 0
        for (k in 0...alphabet.count) {
            var c = alphabet[k]
            if (Char.isAsciiUpper(c)) {
                var d = c.bytes[0] - 65
                if (!used[d]) {
                    _table[i][j] = c
                    used[d] = true
                    j = j + 1
                    if (j == 5) {
                        i = i + 1
                        if (i == 5) break // table has been filled
                        j = 0
                    }
                }
            }
        }
    }

    getCleanText_(plainText) {
        var plainText2 = Str.upper(plainText)  // ensure everything is upper case
        // get rid of any non-letters and insert X between duplicate letters
        var cleanText = ""
        var prevChar = "\0"  // safe to assume null character won't be present in plainText
        for (i in 0...plainText2.count) {
            var nextChar = plainText2[i]
            // It appears that Q should be omitted altogether if NO_Q option is specified - we assume so anyway
            if (Char.isAsciiUpper(nextChar) && (nextChar != "Q" || _pfo != PlayfairOption.NO_Q)) {
                // If I_EQUALS_J option specified, replace J with I
                if (nextChar == "J" && _pfo == PlayfairOption.I_EQUALS_J) nextChar = "I"
                if (nextChar != prevChar) {
                    cleanText = cleanText + nextChar
                } else {
                    cleanText = cleanText + "X" + nextChar
                }
                prevChar = nextChar
            }
        }
        var len = cleanText.count
        if (len % 2 == 1)  {  // dangling letter at end so add another letter to complete digram
            if (cleanText[-1] != "X") {
                cleanText = cleanText + "X"
            } else {
                cleanText = cleanText + "Z"
            }
        }
        return cleanText
    }

    findChar_(c) {
       for (i in 0..4) {
           for (j in 0..4) if (_table[i][j] == c) return [i, j]
       }
       return [-1, -1]
    }

    encode(plainText) {
        var cleanText = getCleanText_(plainText)
        var cipherText = ""
        var length = cleanText.count
        for (i in Stepped.new(0...length, 2)) {
            var pair = findChar_(cleanText[i])
            var row1 = pair[0]
            var col1 = pair[1]
            pair = findChar_(cleanText[i + 1])
            var row2 = pair[0]
            var col2 = pair[1]
            cipherText = cipherText +
                ((row1 == row2) ? _table[row1][(col1 + 1) % 5] +_table[row2][(col2 + 1) % 5] :
                 (col1 == col2) ? _table[(row1 + 1) % 5][col1] +_table[(row2 + 1) % 5][col2] :
                                  _table[row1][col2] +_table[row2][col1])
            if (i < length - 1) cipherText = cipherText + " "
        }
        return cipherText
    }

    decode(cipherText) {
        var decodedText = ""
        var length = cipherText.count
        for (i in Stepped.new(0...length, 3)) {  // cipherText will include spaces so we need to skip them
            var pair = findChar_(cipherText[i])
            var row1 = pair[0]
            var col1 = pair[1]
            pair = findChar_(cipherText[i + 1])
            var row2 = pair[0]
            var col2 = pair[1]
            decodedText = decodedText +
                ((row1 == row2) ? _table[row1][(col1 > 0) ? col1-1 : 4] +_table[row2][(col2 > 0) ?  col2-1 : 4] :
                 (col1 == col2) ? _table[(row1 > 0) ? row1-1 : 4][col1] +_table[(row2 > 0) ? row2-1 : 4][col2] :
                                  _table[row1][col2] +_table[row2][col1])
            if (i < length - 1) decodedText = decodedText + " "
        }
        return decodedText
    }

    printTable() {
        System.print("The_table to be used is :\n")
        for (i in 0..4) {
            for (j in 0..4) System.write(_table[i][j] + " ")
            System.print()
        }
    }
}

var keyword = Input.text("Enter Playfair keyword : ", 1)
var ignoreQ = Str.lower(Input.option("Ignore Q when building_table y/n : ", "yYnN"))
var pfo = (ignoreQ == "y") ? PlayfairOption.NO_Q : PlayfairOption.I_EQUALS_J
var playfair = Playfair.new(keyword, pfo)
playfair.printTable()
var plainText = Input.text("\nEnter plain text : ")
var encodedText = playfair.encode(plainText)
System.print("\nEncoded text is : %(encodedText)")
var decodedText = playfair.decode(encodedText)
System.print("Decoded text is : %(decodedText)")
