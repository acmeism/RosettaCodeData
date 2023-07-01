import Foundation

func fourIsMagic(_ number: NSNumber) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    formatter.locale = Locale(identifier: "en_EN")

    var result: [String] = []

    var numberString = formatter.string(from: number)!
    result.append(numberString.capitalized)

    while numberString != "four" {
        numberString = formatter.string(from: NSNumber(value: numberString.count))!
        result.append(contentsOf: [" is ", numberString, ", ", numberString])
    }

    result.append(" is magic.")
    return result.joined()
}

for testInput in [23, 1000000000, 20140, 100, 130, 151, -7] {
    print(fourIsMagic(testInput as NSNumber))
}
