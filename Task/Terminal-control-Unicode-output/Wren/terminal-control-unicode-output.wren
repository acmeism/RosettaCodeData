import "os" for Terminal

if (Terminal.supportsUnicode) {
    System.print("Unicode is supported on this terminal and U+25B3 is : \u25b3")
} else {
    System.print("Unicode is not supported on this terminal.")
}
