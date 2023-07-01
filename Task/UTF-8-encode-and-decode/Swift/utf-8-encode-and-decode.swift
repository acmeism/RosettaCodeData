import Foundation

func encode(_ scalar: UnicodeScalar) -> Data {
  return Data(String(scalar).utf8)
}

func decode(_ data: Data) -> UnicodeScalar? {
  guard let string = String(data: data, encoding: .utf8) else {
    assertionFailure("Failed to convert data to a valid String")
    return nil
  }
  assert(string.unicodeScalars.count == 1, "Data should contain one scalar!")
  return string.unicodeScalars.first
}

for scalar in "AöЖ€𝄞".unicodeScalars {
  let bytes = encode(scalar)
  let formattedBytes = bytes.map({ String($0, radix: 16)}).joined(separator: " ")
  let decoded = decode(bytes)!
  print("character: \(decoded), code point: U+\(String(scalar.value, radix: 16)), \tutf-8: \(formattedBytes)")
}
