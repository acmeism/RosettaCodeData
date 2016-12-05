import Foundation

let str = "the quick brown fox jumps over the lazy dog"

func isPangram(str:String) -> Bool {
    let stringArray = Array(str.lowercaseString)
    for char in "abcdefghijklmnopqrstuvwxyz" {
        if (find(stringArray, char) == nil) {
            return false
        }
    }
    return true
}

isPangram(str) // True
isPangram("Test string") // False
