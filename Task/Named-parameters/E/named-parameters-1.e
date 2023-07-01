def printName([=> first := null, => last := null]) {
    if (last == null) {
        print("?")
    } else {
        print(last)
    }
    if (first != null) {
        print(", ")
        print(first)
    }
}
