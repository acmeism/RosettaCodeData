import Foundation

// "WWWBWW" -> [(3, W), (1, B), (2, W)]
func encode(input: String) -> [(Int, Character)] {
    return input.characters.reduce([(Int, Character)]()) {
        if $0.last?.1 == $1 { var r = $0; r[r.count - 1].0++; return r }
        return $0 + [(1, $1)]
    }
}

// [(3, W), (1, B), (2, W)] -> "WWWBWW"
func decode(encoded: [(Int, Character)]) -> String {
    return encoded.reduce("") { $0 + String(count: $1.0, repeatedValue: $1.1) }
}
