func isVowel(_ char: Character) -> Bool {
    switch (char) {
    case "a", "A", "e", "E", "i", "I", "o", "O", "u", "U":
        return true
    default:
        return false
    }
}

func removeVowels(string: String) -> String {
    return string.filter{!isVowel($0)}
}

let str = "The Swift Programming Language"
print(str)
print(removeVowels(string: str))
