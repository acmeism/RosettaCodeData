func makeList(_ separator: String) -> String {
  var counter = 1

  func makeItem(_ item: String) -> String {
    let result = String(counter) + separator + item + "\n"
    counter += 1
    return result
  }

  return makeItem("first") + makeItem("second") + makeItem("third")
}

print(makeList(". "))
