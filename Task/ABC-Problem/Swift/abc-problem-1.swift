import Foundation

func Blockable(str: String) -> Bool {

    var blocks = [
        "BO", "XK", "DQ", "CP", "NA", "GT", "RE", "TG", "QD", "FS",
        "JW", "HU", "VI", "AN", "OB", "ER", "FS", "LY", "PC", "ZM" ]

    var strUp = str.uppercaseString
    var final = ""

    for char: Character in strUp {
        var CharString: String = ""; CharString.append(char)
        for j in 0..<blocks.count {
            if blocks[j].hasPrefix(CharString) ||
               blocks[j].hasSuffix(CharString) {
                final.append(char)
                blocks[j] = ""
                break
            }
        }
    }

    return final == strUp
}

func CanOrNot(can: Bool) -> String {
    return can ? "can" : "cannot"
}

for str in [ "A", "BARK", "BooK", "TrEaT", "comMON", "sQuAd", "Confuse" ] {
    println("'\(str)' \(CanOrNot(Blockable(str))) be spelled with blocks.")
}
