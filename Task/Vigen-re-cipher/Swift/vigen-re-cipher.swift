public func convertToUnicodeScalars(
  str: String,
  minChar: UInt32,
  maxChar: UInt32
) -> [UInt32] {
  var scalars = [UInt32]()

  for scalar in str.unicodeScalars {
    let val = scalar.value

    guard val >= minChar && val <= maxChar else {
      continue
    }

    scalars.append(val)
  }

  return scalars
}

public struct Vigenere {
  private let keyScalars: [UInt32]
  private let smallestScalar: UInt32
  private let largestScalar: UInt32
  private let sizeAlphabet: UInt32

  public init?(key: String, smallestCharacter: Character = "A", largestCharacter:  Character = "Z") {
    let smallScalars = smallestCharacter.unicodeScalars
    let largeScalars = largestCharacter.unicodeScalars

    guard smallScalars.count == 1, largeScalars.count == 1 else {
      return nil
    }

    self.smallestScalar = smallScalars.first!.value
    self.largestScalar = largeScalars.first!.value
    self.sizeAlphabet = (largestScalar - smallestScalar) + 1

    let scalars = convertToUnicodeScalars(str: key, minChar: smallestScalar, maxChar: largestScalar)

    guard !scalars.isEmpty else {
      return nil
    }

    self.keyScalars = scalars

  }

  public func decrypt(_ str: String) -> String? {
    let txtBytes = convertToUnicodeScalars(str: str, minChar: smallestScalar, maxChar: largestScalar)

    guard !txtBytes.isEmpty else {
      return nil
    }

    var res = ""

    for (i, c) in txtBytes.enumerated() where c >= smallestScalar && c <= largestScalar {
      guard let char =
        UnicodeScalar((c &+ sizeAlphabet &- keyScalars[i % keyScalars.count]) % sizeAlphabet &+ smallestScalar)
      else {
        return nil
      }

      res += String(char)
    }

    return res
  }

  public func encrypt(_ str: String) -> String? {
    let txtBytes = convertToUnicodeScalars(str: str, minChar: smallestScalar, maxChar: largestScalar)

    guard !txtBytes.isEmpty else {
      return nil
    }

    var res = ""

    for (i, c) in txtBytes.enumerated() where c >= smallestScalar && c <= largestScalar {
      guard let char =
        UnicodeScalar((c &+ keyScalars[i % keyScalars.count] &- 2 &* smallestScalar) % sizeAlphabet &+ smallestScalar)
      else {
        return nil
      }

      res += String(char)
    }

    return res
  }
}

let text = "Beware the Jabberwock, my son! The jaws that bite, the claws that catch!";
let key = "VIGENERECIPHER";
let cipher = Vigenere(key: key)!

print("Key: \(key)")
print("Plain Text: \(text)")

let encoded = cipher.encrypt(text.uppercased())!

print("Cipher Text: \(encoded)")

let decoded = cipher.decrypt(encoded)!

print("Decoded: \(decoded)")

print("\nLarger set:")

let key2 = "Vigenère cipher"
let text2 = "This is a ünicode string 😃"

let cipher2 = Vigenere(key: key2, smallestCharacter: " ", largestCharacter: "🛹")!

print("Key: \(key2)")
print("Plain Text: \(text2)")

let encoded2 = cipher2.encrypt(text2)!

print("Cipher Text: \(encoded2)")

let decoded2 = cipher2.decrypt(encoded2)!

print("Decoded: \(decoded2)")
