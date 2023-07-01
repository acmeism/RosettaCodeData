let flag = "🇵🇷"
print(flag.characters.count)
// Prints "1"
print(flag.unicodeScalars.count)
// Prints "2"
print(flag.utf16.count)
// Prints "4"
print(flag.utf8.count)
// Prints "8"

let nfc = "\u{01FA}"//Ǻ LATIN CAPITAL LETTER A WITH RING ABOVE AND ACUTE
let nfd = "\u{0041}\u{030A}\u{0301}"//Latin Capital Letter A + ◌̊ COMBINING RING ABOVE + ◌́ COMBINING ACUTE ACCENT
let nfkx = "\u{FF21}\u{030A}\u{0301}"//Fullwidth Latin Capital Letter A + ◌̊ COMBINING RING ABOVE + ◌́ COMBINING ACUTE ACCENT
print(nfc == nfd) //NFx: true
print(nfc == nfkx) //NFKx: false
