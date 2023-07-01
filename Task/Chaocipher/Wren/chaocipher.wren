class Chao {
    static encrypt { 0 }
    static decrypt { 1 }

    static exec(text, mode, showSteps) {
        var len = text.count
        if (len != text.bytes.count) Fiber.abort("Text contains non-ASCII characters.")
        var left  = "HXUCZVAMDSLKPEFJRIGTWOBNYQ"
        var right = "PTLNBQDEOYSFAVZKGJRIHWXUMC"
        var eText = List.filled(len, "")
        var temp  = List.filled(26, "")
        for (i in 0...len) {
            if (showSteps) System.print("%(left)  %(right)")
            var index
            if (mode == Chao.encrypt) {
                index = right.indexOf(text[i])
                eText[i] = left[index]
            } else {
                index = left.indexOf(text[i])
                eText[i] = right[index]
            }
            if (i == len - 1) break

            // permute left
            for (j in index..25) temp[j-index] = left[j]
            for (j in 0...index) temp[26-index+j] = left[j]
            var store = temp[1]
            for (j in 2..13) temp[j-1] = temp[j]
            temp[13] = store
            left = temp.join()

            // permute right
            for (j in index..25) temp[j-index] = right[j]
            for (j in 0...index) temp[26-index+j] = right[j]
            store = temp[0]
            for (j in 1..25) temp[j-1] = temp[j]
            temp[25] = store
            store = temp[2]
            for (j in 3..13) temp[j-1] = temp[j]
            temp[13] = store
            right = temp.join()
        }
        return eText.join()
    }
}

var plainText = "WELLDONEISBETTERTHANWELLSAID"
System.print("The original plaintext is : %(plainText)")
System.write("\nThe left and right alphabets after each permutation ")
System.print("during encryption are :\n")
var cipherText = Chao.exec(plainText, Chao.encrypt, true)
System.print("\nThe ciphertext is : %(cipherText)")
var plainText2 = Chao.exec(cipherText, Chao.decrypt, false)
System.print("\nThe recovered plaintext is : %(plainText2)")
