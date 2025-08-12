enum Mode {
    case encrypt
    case decrypt
}

class Chaocipher {
    private static let L_ALPHABET = "HXUCZVAMDSLKPEFJRIGTWOBNYQ"
    private static let R_ALPHABET = "PTLNBQDEOYSFAVZKGJRIHWXUMC"

    private static func indexOf(array: [Character], char: Character) -> Int {
        for i in 0..<array.count {
            if array[i] == char {
                return i
            }
        }
        return -1
    }

    private static func exec(text: String, mode: Mode, showSteps: Bool = false) -> String {
        var left = Array(L_ALPHABET)
        var right = Array(R_ALPHABET)
        var eText = [Character](repeating: " ", count: text.count)
        var temp = [Character](repeating: " ", count: 26)

        let textChars = Array(text)

        for i in 0..<text.count {
            if showSteps {
                print("\(String(left))  \(String(right))")
            }

            let index: Int
            if mode == .encrypt {
                index = indexOf(array: right, char: textChars[i])
                eText[i] = left[index]
            } else {
                index = indexOf(array: left, char: textChars[i])
                eText[i] = right[index]
            }

            if i == text.count - 1 {
                break
            }

            // permute left
            temp[0..<(26-index)] = left[index..<26]
            temp[(26-index)..<26] = left[0..<index]
            let store = temp[1]
            temp[1..<13] = temp[2..<14]
            temp[13] = store
            left = temp

            // permute right
            temp[0..<(26-index)] = right[index..<26]
            temp[(26-index)..<26] = right[0..<index]
            let store1 = temp[0]
            temp[0..<25] = temp[1..<26]
            temp[25] = store1
            let store2 = temp[2]
            temp[2..<13] = temp[3..<14]
            temp[13] = store2
            right = temp
        }

        return String(eText)
    }

    static func encrypt(text: String, showSteps: Bool = false) -> String {
        return exec(text: text, mode: .encrypt, showSteps: showSteps)
    }

    static func decrypt(text: String, showSteps: Bool = false) -> String {
        return exec(text: text, mode: .decrypt, showSteps: showSteps)
    }
}

// Main program
let plainText = "WELLDONEISBETTERTHANWELLSAID"
print("The original plaintext is : \(plainText)")
print("\nThe left and right alphabets after each permutation during encryption are:")
let cipherText = Chaocipher.encrypt(text: plainText, showSteps: true)
print("\nThe cipher text is : \(cipherText)")
let plainText2 = Chaocipher.decrypt(text: cipherText)
print("\nThe recovered plaintext is : \(plainText2)")
