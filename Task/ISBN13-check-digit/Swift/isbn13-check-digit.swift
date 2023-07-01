func checkISBN(isbn: String) -> Bool {
  guard !isbn.isEmpty else {
    return false
  }

  let sum = isbn
    .compactMap({ $0.wholeNumberValue })
    .enumerated()
    .map({ $0.offset & 1 == 1 ? 3 * $0.element : $0.element })
    .reduce(0, +)

  return sum % 10 == 0
}

let cases = [
  "978-1734314502",
  "978-1734314509",
  "978-1788399081",
  "978-1788399083"
]

for isbn in cases {
  print("\(isbn) => \(checkISBN(isbn: isbn) ? "good" : "bad")")
}
